//
//  IGEODownloadsConfigsThread.m
//  IGEOApp
//
//  Created by Bitcliq on 26/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEODownloadsConfigsThread.h"
#import "IGEOFileUtils.h"
#import "IGEODataManager.h"
#import "IGEOConfigsManager.h"
#import "IGEOHomeScreenConfigs.h"
#import "IGEOListScreenConfig.h"
#import "IGEOOptionsScreenConfig.h"
#import "IGEOButtonElement.h"
#import "IGEONativeMapScreenConfig.h"

@interface IGEODownloadsConfigsThread()

//estado atual em que a thread se encontra
@property (nonatomic) IGEOThreadDownloadState actualState;
//Variável utilizada para guardar os bytes recebidos do servidor
@property (nonatomic, strong) NSMutableData *receivedData;
//Thread que é lançada pela thread atual para fazer o download de uma imagem
@property (nonatomic, strong) NSThread *downloadThread;

@end


@implementation IGEODownloadsConfigsThread

@synthesize downloadItemsQueue = _downloadItemsQueue;
@synthesize actualItem = _actualItem;

@synthesize actualState = _actualState;
@synthesize receivedData = _receivedData;


-(id) init {
    if ( self = [super init] ) {
        _actualState = OnPause;
        //adicionar o observer para receber o resultado das listas
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(downloadFinished:)
                                                     name:@"DowloadFinished"
                                                   object:nil];
        
        _downloadItemsQueue = [[NSMutableArray alloc] init];
    }
    return self;
}


-(NSMutableArray *) downloadItemsQueue {
    if(_downloadItemsQueue == nil)
        _downloadItemsQueue = [[NSMutableArray alloc] init];
    
    return _downloadItemsQueue;
}


/**
 Cancela a execução da thread parando a thread dos downloads caso existam downloads em curso.
 */
-(void) cancel
{
    if([_downloadThread isExecuting]){
        [_downloadThread cancel];
        _downloadThread = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super cancel];
}



#pragma mark - métodos de acesso público

/**
 Adiciona um item para download. Caso não existam items em fila de espera o download é feito imediatamente, caso contrário,
 é colocado em fila de espera e o download é feito quando chegar a sua vez.
 */
-(void) addItemToDownload:(IGEOConfigDownloadItem *)item
{
    if(_actualState == OnPause){
        //fazer o download
        _actualItem = item;
        _actualState = Downloading;
        _downloadThread= [[NSThread alloc] initWithTarget:self selector:@selector(downloadFile) object:nil];
        [_downloadThread start];
    }
    else {
        [self.downloadItemsQueue addObject:item];
    }
}












#pragma mark - método para download chamado pela thread

-(void) downloadFile
{
    // Disable the idle timer
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    
    NSString *fileLocation = _actualItem.url;
    
    //Criar o request
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:fileLocation]
                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                          timeoutInterval:60.0];
    
    //Lança a thread para download da imagem e define a ação a ser executada quando esta termina a sua tarefa.
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data){
            self.receivedData = [data mutableCopy];
        }
        else if (error)
            NSLog(@"%@",error);
        
        @try {
            //Faz um post da notificação para que a thread que a chamou execute a ação pretendida no final dos downloads dos itens
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DowloadFinished" object:self];
        }
        @catch (NSException *err) {
            
        }
        
    }];
    
    fileLocation = nil;
    theRequest = nil;
}





#pragma mark - notification handlers

-(void) didFinishDownload:(IGEOConfigDownloadItem *) item
{
    //Escrecve no ficheiro os bytes obtidos no download
    NSString *docsFolder = [IGEOFileUtils docsPath];
    NSString *filePath = [docsFolder stringByAppendingPathComponent:item.destinationFolder];
    
    [IGEOFileUtils writeFileContent: self.receivedData toPath:filePath];
    
    _actualItem.destinationFolder = filePath;
    
    //adiciona a opção "no-backup" ao ficheiro
    if([IGEOFileUtils addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:filePath]]){
        //NSLog(@"-- IGEODownloadsConfigsThread: do not back up flag added to the zip file: %@",filePath);
    }
    //
    
    //faz um reset aos dados recebidos no download
    self.receivedData.length = 0;
    
    docsFolder = nil;
    filePath = nil;
    
    _actualState = OnPause;
}


-(void) downloadFinished:(NSNotification *) n
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self didFinishDownload:_actualItem];
        
        [self makeAlterationsWithDownloadedItem];
        
        if([_downloadItemsQueue count]>0){
            //fazer o download
            _actualItem = [_downloadItemsQueue objectAtIndex:0];
            _actualState = Downloading;
            [_downloadItemsQueue removeObjectAtIndex:0];
            _downloadThread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadFile) object:nil];
            [_downloadThread start];
        }
        else {
            
        }
    });
}





#pragma mark - métodos para colocação das imagens nos locais corretos

-(void) makeAlterationsWithDownloadedItem
{
    
    switch (_actualItem.type) {
        case HomeBgImage:
            [IGEOConfigsManager setHomeBgImageForSource:_actualItem.srcID url:_actualItem.destinationFolder];
            break;
        case ListBGImage:
            [IGEOConfigsManager setListBgImageForSource:_actualItem.srcID url:_actualItem.destinationFolder];
            break;
        case CatIconNormal:
            [IGEOConfigsManager setCatIconNormalForSource:_actualItem.srcID AndCategory:_actualItem.catID url:_actualItem.destinationFolder];
            break;
        case CatIconSelected:
            [IGEOConfigsManager setCatIconSelectedForSource:_actualItem.srcID AndCategory:_actualItem.catID url:_actualItem.destinationFolder];
            break;
        case CatPinImage:
            [IGEOConfigsManager setCatPinImageForSource:_actualItem.srcID AndCategory:_actualItem.catID url:_actualItem.destinationFolder];
            break;
            
        default:
            break;
    }
    
}





@end
