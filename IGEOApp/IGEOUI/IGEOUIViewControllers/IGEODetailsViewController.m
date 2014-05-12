//
//  IGEODetailsViewController.m
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEODetailsViewController.h"
#import "IGEODataManager.h"
#import "IGEOConfigsManager.h"
#import "IGEOUtils.h"
#import <UIKit/UIKit.h>
#import <UIKit/NSStringDrawing.h>
#import <UIKit/NSText.h>
#import <UIKit/UIStringDrawing.h>
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"

@interface IGEODetailsViewController ()

@property (nonatomic, strong) UIAlertView *alert;

@property (nonatomic) BOOL dataItemReceived;
@property (nonatomic) BOOL  error;
@property (nonatomic, strong) NSThread *threadGetDataItem;
@property (nonatomic, strong) IGEOGenericDataItem *di;
@property (nonatomic, strong) NSString *defaultImageName;
@property (nonatomic, strong) SDWebImageDownloader *downloader;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL webViewLoaded;
@property (nonatomic, strong) UIImage *imageToLoad;

@end

@implementation IGEODetailsViewController

/**
 Estas constantes são utilizadas para redimensionar a scrollview após o carregamento
 do html e da imagem
 */
static const float HEIGHT_SCREEN_3_5 = 480.0f;
static const float NOTIFICATION_BAR_HEIGHT = 20.0f;
static const float MIN_WEBVIEW_SIZE = 240.0f;
static const float DELTAY_3_5 = 160.0f;
static const float DELTAY_4_0 = 290.0f;
static const float DELTA_SCROLL_CONTENT = 60.0f;
//--

@synthesize bBack = _bBack;
@synthesize bHome = _bHome;
@synthesize itemID = _itemID;
@synthesize tTitle = _tTitle;
@synthesize tSource = _tSource;
@synthesize tCategory = _tCategory;
@synthesize webViewDetails = _webViewDetails;
@synthesize scrollView = _scrollView;
@synthesize separatorView = _separatorView;
@synthesize dataItemImage = _dataItemImage;
@synthesize scrollContainer = _scrollContainer;
@synthesize viewLoading = _viewLoading;
@synthesize bBackViewLoading = _bBackViewLoading;
@synthesize bShare = _bShare;
@synthesize tLoadingMessage = _tLoadingMessage;

@synthesize dataItemReceived = _dataItemReceived;
@synthesize error = _error;
@synthesize threadGetDataItem = _threadGetDataItem;
@synthesize di = _di;
@synthesize defaultImageName = _defaultImageName;
@synthesize downloader = _downloader;
@synthesize timer = _timer;
@synthesize webViewLoaded = _webViewLoaded;
@synthesize imageToLoad = _imageToLoad;

static const int TAM_TITLE = 24;
static const int DEFAULT_HEIGHT_IMAGE = 230;


#pragma mark - métodos do viewcontroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self applyConfigs];
    
    [_viewLoading setHidden:NO];
    
    _webViewLoaded = NO;
    
    [_bShare setImage:[UIImage imageNamed:@"share_click"] forState:UIControlStateHighlighted];
    
    // Lançar a thread para obtenção dos dados
    _threadGetDataItem = [[NSThread alloc] initWithTarget:self selector:@selector(getDataItems) object:nil];
    [_threadGetDataItem start];
    
    
    [_tLoadingMessage setText:[IGEOUtils getStringForKey:@"LOADING_DETAILS"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //adicionar o observer para receber o resultado das listas
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFinishLoadDataItemDetails:)
                                                 name:@"FinishLoadDataItemDatails"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveJSONErrorDataItemDetails:)
                                                 name:@"JSONErrorDataItemDatails"
                                               object:nil];
}


-(void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_downloader setDelegate:nil];
    [_downloader cancel];
    _downloader = nil;
    _imageToLoad = nil;
    
    [super viewDidUnload];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_downloader setDelegate:nil];
    [_downloader cancel];
    _downloader = nil;
    
    if(_timer!=nil)
        [_timer invalidate];
    
    [super viewWillDisappear:animated];
}









#pragma mark - método para obtenção do item

-(void) getDataItems
{
    [IGEODataManager getDataItemForID:_itemID];
}








#pragma mark - notifications

//chamada quando termina a obtenção dos detalhes do item.
-(void) receiveFinishLoadDataItemDetails:(NSNotification *) n
{
    if(_dataItemReceived || _error)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([IGEOJSONServerReader temporaryCategories]==nil){
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"DETAILS_ERROR_ALERT_TITLE"]
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else if([[IGEOJSONServerReader temporaryCategories] count]==0){
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"DETAILS_ERROR_ALERT_TITLE"]
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else {
            
            //carregar os dados do item
            _di = (IGEOGenericDataItem *) [IGEOJSONServerReader temporaryDataItem];
            
            _tTitle.text = _di.title;
            _tSource.text = [NSString stringWithFormat:[IGEOUtils getStringForKey:@"SOURCE_TEXT"],[IGEODataManager actualSource].sourcename];
            _tCategory.text = [NSString stringWithFormat:[IGEOUtils getStringForKey:@"CATEGORY_TEXT"], ((IGEOCategory *) [[[IGEODataManager actualSource] categoryDictionary] objectForKey:_di.categoryID]).categoryName];
            
            //load webview
            NSURL *bundleURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]];
            
            NSString* htmlString = [NSString stringWithFormat:[IGEOUtils getStringForKey:@"DETAILS_BASE_HTML"], _di.textOrHTML];
            
            for (id subview in _webViewDetails.subviews)
                if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                    ((UIScrollView *)subview).bounces = NO;
            
            [_webViewDetails loadHTMLString:htmlString baseURL:bundleURL];
            
            _webViewDetails.delegate = self;
            
            [_webViewDetails setUserInteractionEnabled:YES];
            
            [_scrollView setBounces:NO];
            
            //timeout para o loading da webview
            _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelWeb:) userInfo:nil repeats:NO];
            
            bundleURL = nil;
            htmlString = nil;
            //--
            
            
            //resize das das labels do titulo e outros
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_BOLD"] size:TAM_TITLE]};
            CGSize size = [_tTitle.text sizeWithAttributes:attributes];
            if(size.width > _tTitle.bounds.size.width){
                CGRect rTitleView = _tTitle.frame;
                rTitleView.size.height *= (size.width>_tTitle.bounds.size.width*2 ? 5 : 3);
                [_tTitle setFrame:rTitleView];
                
                CGRect rTSource = [_tSource frame];
                rTSource.origin.y = rTitleView.origin.y + rTitleView.size.height;
                [_tSource setFrame:rTSource];
                
                CGRect rTCategory = [_tCategory frame];
                rTCategory.origin.y = rTSource.origin.y + rTSource.size.height;
                [_tCategory setFrame:rTCategory];
                
                CGRect rSeparatorView = [_separatorView frame];
                rSeparatorView.origin.y = rTCategory.origin.y + rTCategory.size.height + 5;
                [_separatorView setFrame:rSeparatorView];
                
                CGRect rWebView = [_webViewDetails frame];
                rWebView.origin.y = rSeparatorView.origin.y + rSeparatorView.size.height + 5;
                [_webViewDetails setFrame:rWebView];
            }
            
            NSDictionary *attributesCategory = @{NSFontAttributeName:[UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:15]};
            CGSize sizeCategory = [_tTitle.text sizeWithAttributes:attributes];
            if(sizeCategory.width > _tCategory.bounds.size.width){
                CGRect rCategory = _tCategory.frame;
                rCategory.size.height *= 3;
                [_tCategory setFrame:rCategory];
                
                CGRect rSeparatorView = [_separatorView frame];
                rSeparatorView.origin.y = rCategory.origin.y + rCategory.size.height;
                [_separatorView setFrame:rSeparatorView];
                
                CGRect rWebView = [_webViewDetails frame];
                rWebView.origin.y = rSeparatorView.origin.y + rSeparatorView.size.height;
                [_webViewDetails setFrame:rWebView];
            }
            
            
            //obter a imagem
            if(_di.imageURL!=nil){
                if(![_di.imageURL isEqualToString:@""]){
                    NSLog(@"imageURL = %@", _di.imageURL);
                    _downloader = [SDWebImageDownloader downloaderWithURL:[NSURL URLWithString:_di.imageURL] delegate:self];
                    _dataItemImage.image = [UIImage imageNamed:_defaultImageName];
                }
            }
            //--
            
            attributes = nil;
            attributesCategory = nil;
            bundleURL = nil;
            htmlString = nil;
            //--
            
        }
    });
    
}


-(void) receiveJSONErrorDataItemDetails:(NSNotification *) n
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_dataItemReceived || _error)
            return;
        
        _dataItemReceived = YES;
        
        ////NSLog(@"Erro no JSON!");
        
        //[_alert dismissWithClickedButtonIndex:0 animated:YES];
        [_viewLoading setHidden:YES];
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"DETAILS_ERROR_ALERT_TITLE"]
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    });
}




#pragma mark - métodos da webviewdelegate

/**
 Após o carregamento da webview, vamos calcular qual o novo tamanho da scrollview necessário para a apresentação
 da imagem e da webview e redimensionar a mesma para esse tamanho.
 */
 
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(_webViewLoaded)
        return;
    
    //NSLog(@"webViewDidFinishLoad");
    [_viewLoading setHidden:YES];
    
    CGRect r = _webViewDetails.frame;
    r.size.height = _webViewDetails.scrollView.contentSize.height;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if(_webViewDetails.scrollView.contentSize.height < MIN_WEBVIEW_SIZE){
        r.size.height = _webViewDetails.scrollView.contentSize.height - ((screenWidth - NOTIFICATION_BAR_HEIGHT) - _webViewDetails.scrollView.contentSize.height);
    }
    
    CGRect rImage = _dataItemImage.frame;
    float deltaY = (screenHeight>HEIGHT_SCREEN_3_5 ? DELTAY_3_5 : DELTAY_4_0);
    
    [_webViewDetails setFrame:r];
    [_scrollView setContentSize:CGSizeMake(screenWidth, _webViewDetails.scrollView.contentSize.height + deltaY + rImage.size.height + DELTA_SCROLL_CONTENT)];
    [_webViewDetails setBackgroundColor:[UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f]];
    [_scrollView setContentSize:CGSizeMake(screenWidth, _webViewDetails.scrollView.contentSize.height + deltaY + rImage.size.height)];
    
    CGRect rContainer = _scrollContainer.frame;
    rContainer.size.height = _webViewDetails.scrollView.contentSize.height + deltaY + rImage.size.height;
    [_scrollContainer setFrame:rContainer];
    
    
    [_webViewDetails.scrollView setScrollEnabled:NO];
    _webViewDetails.opaque = YES;
    _webViewLoaded = YES;
    
    if(_imageToLoad!=nil){
        [self imageDownloader:nil didFinishWithImage:_imageToLoad];
    }
}


//Faz com que os links sejam abertos no Safari e não na propria webview
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}


//cancela o carregamento da webview
-(void) cancelWeb:(NSTimer *) t
{
    [self webViewDidFinishLoad:nil];
}








#pragma mark - clicks nos botões

- (IBAction)bBackClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)bHomeClicked:(id)sender {
    [IGEODataManager clearCurrentFilterCategories];
    [IGEODataManager clearKeywords];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSegueWithIdentifier:@"backHomeFromDetails" sender:self];
}






#pragma mark - aplicação das configs

-(void) applyConfigs
{
    //fontes
    [_tTitle setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_BOLD"] size:24]];
    [_tSource setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:15]];
    [_tCategory setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:15]];
    
    [_bBack setImage:[UIImage imageNamed:@"back_click"] forState:UIControlStateHighlighted];
    [_bHome setImage:[UIImage imageNamed:@"home_click"] forState:UIControlStateHighlighted];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    self.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    
    _defaultImageName = [IGEOConfigsManager getDefaultImage];
    [_dataItemImage setImage:[UIImage imageNamed:_defaultImageName]];
}




#pragma mark - métodos do UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self bBackClicked:nil];
}







#pragma mark - métodos do SDWebImageManagerDelegate

- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image
{
    if(!_webViewLoaded){
        _imageToLoad = image;
        return;
    }
    
    _dataItemImage.image = image;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int w = image.size.width;
    int h = image.size.height;
    int newW = screenWidth;
    
    int newH = (newW*h)/w;
    
    CGRect r = _dataItemImage.frame;
    r.size.height = newH;
    [_dataItemImage setFrame:r];
    
    int deltaH = DEFAULT_HEIGHT_IMAGE - newH;
    
    CGRect rTitle = _tTitle.frame;
    rTitle.origin.y -= deltaH;
    [_tTitle setFrame:rTitle];
    
    CGRect rTSource = _tSource.frame;
    rTSource.origin.y -= deltaH;
    [_tSource setFrame:rTSource];
    
    CGRect rTCategory = _tCategory.frame;
    rTCategory.origin.y -= deltaH;
    [_tCategory setFrame:rTCategory];
    
    CGRect rSeparator = _separatorView.frame;
    rSeparator.origin.y -= deltaH;
    [_separatorView setFrame:rSeparator];
    
    CGRect rWebView = _webViewDetails.frame;
    rWebView.origin.y -= deltaH;
    [_webViewDetails setFrame:rWebView];
    
    //correção do valor da altura da scrollView
    deltaH -= 80;
    
    [_scrollView setContentSize:CGSizeMake(screenWidth, _webViewDetails.scrollView.contentSize.height + 380.0f - deltaH)];
}







#pragma mark - click no back da loadingView

- (IBAction)bBackLoadingViewClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self bBackClicked:nil];
}






#pragma mark - envio via email

- (IBAction)bShareClicked:(id)sender {
    if(!_webViewLoaded)
        return;
    
    [self displayComposerSheet];
}


-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if(picker==nil){
        return;
    }
    
    picker.mailComposeDelegate = self;
    
    [picker setSubject:_di.title];
    
    NSURL *bundleURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]];
    
    NSString* htmlString = [NSString stringWithFormat:[IGEOUtils getStringForKey:@"DETAILS_BASE_HTML"], _di.textOrHTML];
    [picker setMessageBody:htmlString isHTML:YES];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
    picker = nil;
    bundleURL = nil;
    htmlString = nil;
}

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}







@end
