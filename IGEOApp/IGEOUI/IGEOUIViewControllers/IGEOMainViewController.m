//
//  IGEOMainViewController.m
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOMainViewController.h"
#import "IGEOInfoViewController.h"
#import "IGEOSourceListCell.h"
#import "IGEOSource.h"
#import "IGEODataManager.h"
#import "IGEOConfigsManager.h"
#import "IGEOUtils.h"
#import "IGEOSearchQueryBuilder.h"
#import "IGEOOptionsViewController.h"
#import "IGEOLocationManager.h"

@interface IGEOMainViewController ()

//Indica em quql dos três ecrãs estamos neste momento.
@property (nonatomic) int actualScreen;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic) BOOL errorJSON;
@property (nonatomic) BOOL bSearchClicked;

//thread para obtenção das fontes
@property (nonatomic, strong) NSThread *threadGetSources;

@property (nonatomic) BOOL locationInited;
@property (nonatomic) CGFloat screenWidth;

@end

@implementation IGEOMainViewController

@synthesize bgImageView = _bgImageView;
@synthesize scrollViewBg = _scrollViewBg;
@synthesize bSourcesList = _bSourcesList;
@synthesize bNearMe = _bNearMe;
@synthesize bExplore = _bExplore;
@synthesize tTitle = _tTitle;
@synthesize tOpenGeograficData = _tOpenGeograficData;
@synthesize tSubtitle = _tSubtitle;
@synthesize bBack = _bBack;
@synthesize bInfo = _bInfo;
@synthesize bDistricts = _bDistricts;
@synthesize bCouncils = _bCouncils;
@synthesize bParishes = _bParishes;
@synthesize bSearch =_bSearch;
@synthesize tParishes = _tParishes;
@synthesize backExplore = _backExplore;
@synthesize tSources = _tSources;
@synthesize tNearMe = _tNearMe;
@synthesize tExplore = _tExplore;
@synthesize viewLoading = _viewLoading;
@synthesize bBackLoadingView = _bBackLoadingView;
@synthesize tLoadingMessage = _tLoadingMessage;

@synthesize actualScreen = _actualScreen;
@synthesize alert = _alert;
@synthesize sourcesExists = _sourcesExists;
@synthesize errorJSON = _errorJSON;
@synthesize bSearchClicked = _bSearchClicked;
@synthesize threadGetSources = _threadGetSources;
@synthesize locationInited = _locationInited;
@synthesize screenWidth = _screenWidth;

//Estas constantes são utilizadas para a representar cada um dos ecrãs da home
static const int HOME = 0;
static const int SOURCES_LIST = 1;
static const int EXPLORE = 2;

//Indica qual a fonte atualmente selecionada ou -1 caso não esteja selecionada nenhuma fonte
int selectedIndexSource = -1;

static const double ANIMATION_TIME = 0.3;

//SOURCES LIST
@synthesize tableSources = _tableSources;
//--






- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}



#pragma mark - métodos do ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Obtém as configurações do ConfigsManager e aplica-as
    [self applyConfigs];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _screenWidth = screenRect.size.width;
    
    
    //Adicionar o swipe recognizer
    UISwipeGestureRecognizer * recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightActionHOME:)];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizerRight];
    
    UISwipeGestureRecognizer * recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myLeftActionHOME:)];
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizerLeft];
    
    UISwipeGestureRecognizer * recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myUpActionHOME:)];
    [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.view addGestureRecognizer:recognizerUp];
    
    
    
    
    [_bBack setHidden:YES];
    [self setActualScreen:HOME];
    [self.view bringSubviewToFront:_bBack];
    [self.view bringSubviewToFront:_bInfo];
    
    [_bBack setImage:[UIImage imageNamed:@"back_click_new"] forState:UIControlStateHighlighted];
    [_bInfo setImage:[UIImage imageNamed:@"info_click"] forState:UIControlStateHighlighted];
    
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    
    
    
    
    //lista de fontes
    [_tableSources setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
    [_tableSources setBounces:NO];
    [_tableSources setSeparatorColor:[UIColor clearColor]];
    
    // Lançar a thread para obtenção das fontes
    _threadGetSources = [[NSThread alloc] initWithTarget:self selector:@selector(getSourcesList) object:nil];
    [_threadGetSources start];
    
    
    //adicionar o observer para receber o resultado das listas
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFinishLoadSources:)
                                                 name:@"FinishLoadSources"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveJSONError:)
                                                 name:@"JSONError"
                                               object:nil];
    
    
    
    
    //colocar o subtítulo invisível inicialmente
    [_tSubtitle setHidden:YES];
    
    
    
    
    //botões da filtragem do explore
    _bDistricts.layer.borderWidth = 1.0;
    _bDistricts.layer.cornerRadius = 20;
    _bDistricts.layer.borderColor = [UIColor whiteColor].CGColor;
    [_bDistricts setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    _bCouncils.layer.borderWidth = 1.0;
    _bCouncils.layer.cornerRadius = 20;
    _bCouncils.layer.borderColor = [UIColor whiteColor].CGColor;
    [_bCouncils setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    _bParishes.layer.borderWidth = 1.0;
    _bParishes.layer.cornerRadius = 20;
    _bParishes.layer.borderColor = [UIColor whiteColor].CGColor;
    [_bParishes setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    _bSearch.layer.borderWidth = 1.0;
    _bSearch.layer.cornerRadius = 20;
    _bSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    recognizerLeft = nil;
    recognizerRight = nil;
    recognizerUp = nil;
    
    [_viewLoading setHidden:YES];
    
    //se as fontes já foram carregadas e estamos no back da info ou explore,
    //vamos colocar a imagem de fundo da fonte e o seu título
    if([IGEODataManager actualSource] != nil){
        //se escolhemos uma fonte vamos apresentar a sua imagem e o título com o nome da fonte
        [_tSubtitle setText:[IGEODataManager actualSource].sourcename];
        
        CGRect r = _tSubtitle.frame;
        CGSize s;
        r.size.width = [_tSubtitle sizeThatFits:s].width + 15;
        [_tSubtitle setFrame:r];
        
        [_tSubtitle setHidden:NO];
        
        
        //vamos obter a imagem através da pasta da app se o nome da mesma começar por "/", caso contrário obtemo-la da
        //pasta do projeto
        NSString *urlBg = [IGEOConfigsManager getBackgroundImageForSource:[IGEODataManager actualSource].sourceID];
        if([urlBg hasPrefix:@"/"]){
            [_bgImageView setImage:[UIImage imageWithContentsOfFile:urlBg]];
        }
        else {
            [_bgImageView setImage:[UIImage imageNamed:urlBg]];
        }
        
        //Aqui caso tenhamos vindo da seleção de categorias pelo explore e clicado no botão home 
        //vamos para ecrã home deste viewcontroller, evitando voltar para a seleção de categorias
        if(_backExplore){
            CGRect currentScrollViewRect = self.scrollViewBg.frame;
            CGRect currentImageViewRect = self.bgImageView.frame;
            
            [self.scrollViewBg setFrame:CGRectMake(currentScrollViewRect.origin.x - 320.0f, currentScrollViewRect.origin.y,
                                                   currentScrollViewRect.size.width, currentScrollViewRect.size.height)];
            [self.bgImageView setFrame:CGRectMake(currentImageViewRect.origin.x - 320.0f, currentImageViewRect.origin.y,
                                                  currentImageViewRect.size.width, currentImageViewRect.size.height)];
            _actualScreen = EXPLORE;
            
            [_bBack setHidden:NO];
        }
        
        
    }
    
    [_tLoadingMessage setText:[IGEOUtils getStringForKey:@"LOADING_HOME"]];
    
    //Lê do servidor as configurações relativas à imagem de fundo por defeito da home e da lista de items.
    [IGEOConfigsManager readDefaultConfigs];
    
    //vefrificação da ligação à internet
    if(![IGEOUtils isNetworkAvailable]){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_INTERNET_CONNECTION"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        
        _sourcesExists = NO;
    }
    
}



-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Inicializa o a lista de distritos, concelhos e freguesias, para o caso em que voltamos para a home, mas tinhamos já
    //selecionados o distrito, e/ou concelho, e/ou freguesia.
    IGEOSearchQueryBuilder * sqb = [IGEOSearchQueryBuilder sharedEntitySearchQueryBuilder];
    
    if(sqb.districtID!=-1){
        [_tDistricts setText:sqb.district];
    }
    else {
        [_tDistricts setText:[IGEOUtils getStringForKey:@"LOCATION_SELECT"]];
        [_tCouncils setText:[IGEOUtils getStringForKey:@"LOCATION_SELECT"]];
        [_tParishes setText:[IGEOUtils getStringForKey:@"LOCATION_SELECT"]];
    }
    if(sqb.councilID!=-1){
        [_tCouncils setText:sqb.council];
    }
    else {
        [_tCouncils setText:[IGEOUtils getStringForKey:@"LOCATION_SELECT"]];
        [_tParishes setText:[IGEOUtils getStringForKey:@"LOCATION_SELECT"]];
    }
    if(sqb.parishID!=-1){
        [_tParishes setText:sqb.parish];
    }
    else {
        [_tParishes setText:[IGEOUtils getStringForKey:@"LOCATION_SELECT"]];
    }
    
}




-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gotoInfoFromHome"]){
        [((IGEOInfoViewController *) segue.destinationViewController) setFromHome:YES];
    }
    else if([segue.identifier isEqualToString:@"showPlacesList"]){
        IGEOSearchQueryBuilder * x = (IGEOSearchQueryBuilder *) sender;
        
        x = nil;
    }
    else if([segue.identifier isEqualToString:@"gotoOptions"]){
        IGEOSearchQueryBuilder * sqb = [IGEOSearchQueryBuilder sharedEntitySearchQueryBuilder];
        
        IGEOOptionsViewController *destViewController = (IGEOOptionsViewController *) segue.destinationViewController;
        
        if(_bSearchClicked){
            [IGEODataManager setLocationSearchDistrict:[NSString stringWithFormat:@"%ld",(long)sqb.districtID] council:[NSString stringWithFormat:@"%ld",(long)sqb.councilID] parish:(sqb.parishID!=-1 ? [NSString stringWithFormat:@"%ld",(long)sqb.parishID] : nil)];
            
            
            if(_bSearchClicked)
                [destViewController setFromExplore:YES];
            
        }
        
        [destViewController setIsStartingLocationNow:_locationInited];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewDidUnload
{
    
    //remover os observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FinishLoadSources" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JSONError" object:nil];
    
    [[NSThread alloc] cancel];
    _threadGetSources = nil;
    
    [super viewDidUnload];
}










#pragma mark - métodos do swipe

//na home estes métodos são usados para alternar entre os 3 ecrãs (lista de fontes, home e filtragem de localização do explore) e
//ainda para irmos para a seleção de categorias.
-(void) myRightActionHOME:(UISwipeGestureRecognizer*)recognizer
{
    if(_actualScreen == SOURCES_LIST){
        return;
    }
    //verificação da ligação à internet
    if(![IGEOUtils isNetworkAvailable]){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_INTERNET_CONNECTION"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        
        _sourcesExists = NO;
        
        return;
    }
    
    //NSLog(@"swiperight");
    if(_actualScreen == HOME){
        [self gotoSourcesList];
        [self setActualScreen:SOURCES_LIST];
    }
    else {
        [self backFromExplore];
        [self setActualScreen:HOME];
    }
}
-(void) myLeftActionHOME:(UISwipeGestureRecognizer *) r
{
    if(_actualScreen == EXPLORE){
        return;
    }
    //vefrificação da ligação à internet
    if(![IGEOUtils isNetworkAvailable]){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_INTERNET_CONNECTION"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        
        _sourcesExists = NO;
        
        return;
    }
    
    if([IGEODataManager actualSource] == nil && _actualScreen != SOURCES_LIST){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"SELECT_SOURCE_MESSAGE"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        
        return;
    }
    
    //NSLog(@"swipe left");
    if(_actualScreen == HOME){
        [self gotoExplore];
        [self setActualScreen:EXPLORE];
    }
    else {
        [self backFromSourcesList];
        [self setActualScreen:HOME];
    }
}
-(void) myUpActionHOME:(UISwipeGestureRecognizer *) r
{
    //NSLog(@"swipe up");
    
    //vefrificação da ligação à internet
    if(![IGEOUtils isNetworkAvailable]){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_INTERNET_CONNECTION"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        
        _sourcesExists = NO;
        
        return;
    }
    
    [self bNearMeClicked:nil];
}












#pragma mark - Cliques nos botões da Home
- (IBAction)bSourceListClicked:(id)sender {
    [self setActualScreen:SOURCES_LIST];
    [self gotoSourcesList];
}


- (IBAction)bNearMeClicked:(id)sender {
    if([IGEODataManager actualSource] == nil){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"SELECT_SOURCE_MESSAGE"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    }
    else {
        
        //verificação da ligação à internet
        if(![IGEOUtils isNetworkAvailable]){
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_INTERNET_CONNECTION"]
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
            
            _sourcesExists = NO;
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _locationInited = NO;
            
            if([[IGEOLocationManager sharedLocationManager] actualLocation]==nil){
                [[IGEOLocationManager sharedLocationManager] initLocationListening];
                [[IGEOLocationManager sharedLocationManager] startListeningLocation];
                _locationInited = YES;
            }
            else if([[IGEOLocationManager sharedLocationManager] actualLocation].coordinate.latitude<=0.0f){
                [[IGEOLocationManager sharedLocationManager] initLocationListening];
                [[IGEOLocationManager sharedLocationManager] startListeningLocation];
                _locationInited = YES;
            }
            
            if(_locationInited){
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                                  target: self
                                                                selector: @selector(gotoOptionsAsync:)
                                                                userInfo: nil
                                                                 repeats: NO];
                
                timer = nil;
            }
            else {
                [self performSegueWithIdentifier:@"gotoOptions" sender:self];
            }
        });
        
    }
}


//Vai para as opções
-(void) gotoOptionsAsync:(NSTimer *) t
{
    //verificação da ligação à internet
    if(![IGEOUtils isNetworkAvailable]){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_INTERNET_CONNECTION"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        
        _sourcesExists = NO;
        
        return;
    }
    
    [self performSegueWithIdentifier:@"gotoOptions" sender:self];
}


/**
 Clique no botão de ida para o explore
 */
- (IBAction)bExploreClicked:(id)sender {
    if([IGEODataManager actualSource] == nil){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"SELECT_SOURCE_MESSAGE"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    }
    else {
        
        if(![IGEOUtils isNetworkAvailable]){
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_INTERNET_CONNECTION"]
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
            
            _sourcesExists = NO;
            
            return;
        }
        
        [self setActualScreen:EXPLORE];
        [self gotoExplore];
    }
}


- (IBAction)bBackClicked:(id)sender {
    if(_actualScreen == SOURCES_LIST){
        [self backFromSourcesList];
    }
    else if(_actualScreen == EXPLORE){
        [self backFromExplore];
    }
    
    [self setActualScreen:HOME];
}











#pragma mark - ação de mover para a esquerda, direita e backs

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self backFromSourcesList];
    _errorJSON = NO;
    //[NSThread detachNewThreadSelector:@selector(getSourcesList) toTarget:self withObject:nil];
    _threadGetSources = [[NSThread alloc] initWithTarget:self selector:@selector(getSourcesList) object:nil];
    [_threadGetSources start];
}

/**
 Método usado para a obtenção da lista de fontes.
 */
-(void) gotoSourcesList
{
    [_tSubtitle setHidden:YES];
    
    if(!_sourcesExists && _tableSources!=nil) {
        if([_tableSources numberOfSections]>0)
            _sourcesExists = YES;
    }
    if(![IGEOUtils isNetworkAvailable]){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_INTERNET_CONNECTION"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        
        _sourcesExists = NO;
        
        return;
    }
    
    if(!_sourcesExists){
        //inicial a obtenção de sources
        if(!_errorJSON){
            [_viewLoading setHidden:NO];
        }
        else {
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_INTERNET_CONNECTION"]
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
    }
    
    CGRect currentScrollViewRect = self.scrollViewBg.frame;
    CGRect currentImageViewRect = self.bgImageView.frame;
    
    //A alteração entre os ecrãs da home é feita através de uma animação que faz o deslize do scroll.
    [UIView animateWithDuration:ANIMATION_TIME
                     animations:^{
                         [self.scrollViewBg setFrame:CGRectMake(currentScrollViewRect.origin.x + 320.0f, currentScrollViewRect.origin.y,
                                                                currentScrollViewRect.size.width, currentScrollViewRect.size.height)];
                         [self.bgImageView setFrame:CGRectMake(currentImageViewRect.origin.x + 320.0f, currentImageViewRect.origin.y,
                                                               currentImageViewRect.size.width, currentImageViewRect.size.height)];
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             [_bBack setHidden:NO];
                         }
                     }
     ];
}


/**
 Back da lista de fontes para a home.
 */
-(void) backFromSourcesList
{
    if([IGEODataManager actualSource]!=nil)
        [_tSubtitle setHidden:NO];
    
    if(!_sourcesExists){
        [_viewLoading setHidden:YES];
    }
    
    [_bBack setHidden:YES];
    
    CGRect currentScrollViewRect = self.scrollViewBg.frame;
    CGRect currentImageViewRect = self.bgImageView.frame;
    
    //semelhante ao que acontece no método anterior
    [UIView animateWithDuration:ANIMATION_TIME
                     animations:^{
                         [self.scrollViewBg setFrame:CGRectMake(currentScrollViewRect.origin.x - _screenWidth, currentScrollViewRect.origin.y,
                                                                currentScrollViewRect.size.width, currentScrollViewRect.size.height)];
                         [self.bgImageView setFrame:CGRectMake(currentImageViewRect.origin.x - _screenWidth, currentImageViewRect.origin.y,
                                                               currentImageViewRect.size.width, currentImageViewRect.size.height)];
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             [self setActualScreen:HOME];
                         }
                     }
     ];
}


/**
 Ida para o explore
 */
-(void) gotoExplore
{
    CGRect currentScrollViewRect = self.scrollViewBg.frame;
    CGRect currentImageViewRect = self.bgImageView.frame;
    
    //semelhante ao que acontece no método anterior
    [UIView animateWithDuration:ANIMATION_TIME
                     animations:^{
                         [self.scrollViewBg setFrame:CGRectMake(currentScrollViewRect.origin.x - _screenWidth, currentScrollViewRect.origin.y,
                                                                currentScrollViewRect.size.width, currentScrollViewRect.size.height)];
                         [self.bgImageView setFrame:CGRectMake(currentImageViewRect.origin.x - _screenWidth, currentImageViewRect.origin.y,
                                                               currentImageViewRect.size.width, currentImageViewRect.size.height)];
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             [_bBack setHidden:NO];
                         }
                     }
     ];
}


/**
 Back do explore para a home.
 */
-(void) backFromExplore
{
    [_bBack setHidden:YES];
    
    CGRect currentScrollViewRect = self.scrollViewBg.frame;
    CGRect currentImageViewRect = self.bgImageView.frame;
    
    //semelhante ao que acontece no método anterior
    [UIView animateWithDuration:ANIMATION_TIME
                     animations:^{
                         [self.scrollViewBg setFrame:CGRectMake(currentScrollViewRect.origin.x + _screenWidth, currentScrollViewRect.origin.y,
                                                                currentScrollViewRect.size.width, currentScrollViewRect.size.height)];
                         [self.bgImageView setFrame:CGRectMake(currentImageViewRect.origin.x + _screenWidth, currentImageViewRect.origin.y,
                                                               currentImageViewRect.size.width, currentImageViewRect.size.height)];
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             [self setActualScreen:HOME];
                         }
                     }
     ];
}






















#pragma mark - sources list

#pragma mark - Table view datasource

//Estes métodos são utilizados na construção da lista de fontes.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([IGEOJSONServerReader temporarySources]!=nil)
        return [[IGEOJSONServerReader temporarySources] count];
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}


- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section!=0)
        return 8.0f;
    else
        return 0.0f;
}


/**
 Coloca a lista de fontes sem uma view de header, permitindo assim, que não exista um padding entre o primeiro item e o
 inicio do scroll.
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sec = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    [sec setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
    return sec;
}


/**
 Constrói a tabela através das fontes lidas do servidor.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SourcesListCell";
    
    if([[IGEOJSONServerReader temporarySources] count] == 0)
        return nil;
    
    IGEOSourceListCell *cell = (IGEOSourceListCell *)[_tableSources dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IGEOSourceListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    //obter a fonte pela posição
    IGEOSource *s = [[IGEOJSONServerReader temporarySources] objectAtIndex:indexPath.section];
    
    cell.tName.text = s.sourcename;
    cell.tSubtitle.text = s.srcSubtitle;
    
    
    //fontes
    [cell.tName setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_LIGHT"] size:18]];
    [cell.tSubtitle setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_LIGHT"] size:15]];
    //--
    
    //limpar cor de fundo para não ficar opaco
    cell.backgroundColor = [UIColor clearColor];
    [tableView setBackgroundColor:[UIColor clearColor]];
    
    //definir a view de seleção
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
    bgView.backgroundColor = [IGEOUtils colorWithHexString:[[IGEOConfigsManager getAppConfigs] appColor] alpha:0.6f];
    cell.selectedBackgroundView = bgView;
    
    //retirar o separador entre células
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    if([IGEODataManager actualSource] != nil){
        if([[IGEODataManager actualSource].sourcename isEqualToString:s.sourcename]){
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:indexPath.section];
        }
    }
    
    return cell;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[IGEOConfigsManager getAppConfigs].appSourcesHashMap allValues] count] == 0)
        return;
    
    if(indexPath.section==selectedIndexSource){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        selectedIndexSource = -1;
        [_tSubtitle setHidden:YES];
        [IGEODataManager clearActualSource];
        
        //semelhante ao já explicado para o carregamento de outras imagens das configurações
        NSString *urlBg = [IGEOConfigsManager getBackgroundImageForSource:@"-1"];
        if([urlBg hasPrefix:@"/"]){
            [_bgImageView setImage:[UIImage imageWithContentsOfFile:urlBg]];
        }
        else {
            [_bgImageView setImage:[UIImage imageNamed:urlBg]];
        }
    } else {
        selectedIndexSource = (int) indexPath.section;
        
        //semelhante ao já explicado para o carregamento de outras imagens das configurações
        [_tSubtitle setText:[((IGEOSource *) [[[IGEOConfigsManager getAppConfigs].appSourcesHashMap allValues] objectAtIndex:indexPath.section]) sourcename]];
        
        //colocação do padding no nome da fonte
        CGRect r = _tSubtitle.frame;
        CGSize s;
        r.size.width = [_tSubtitle sizeThatFits:s].width + 15;
        [_tSubtitle setFrame:r];
        
        [_tSubtitle setHidden:NO];
        
        //coloca na fonte atual a fonte selecionada
        [IGEODataManager setACtualSource:((IGEOSource *) [[[IGEOConfigsManager getAppConfigs].appSourcesHashMap allValues] objectAtIndex:indexPath.section])];
        
        //semelhante ao já explicado para o carregamento de outras imagens das configurações
        NSString *urlBg = [IGEOConfigsManager getBackgroundImageForSource:[IGEODataManager actualSource].sourceID];
        NSLog(@"urlBg = %@", urlBg);
        if([urlBg hasPrefix:@"/"]){
            [_bgImageView setImage:[UIImage imageWithContentsOfFile:urlBg]];
        }
        else {
            [_bgImageView setImage:[UIImage imageNamed:urlBg]];
        }
    }
    
    [self backFromSourcesList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}














#pragma mark - obtenção de dados

-(void) getSourcesList
{
    //obtém as fontes através do DataManager
    [IGEODataManager getSourcesList];
    
}










#pragma mark - notifications

/**
 Este método é usado para após obtermos as fontes, carregar na lista de fontes.
 */
-(void) receiveFinishLoadSources:(NSNotification *) n
{
    NSLog(@"Sources received!");
    
    _errorJSON = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([[IGEOJSONServerReader temporarySources] count] > 0){
            //reload da tabela
            [[IGEOConfigsManager getAppConfigs] setSourcesList:[IGEOJSONServerReader temporarySources]];
            [_tableSources reloadData];
            _sourcesExists = YES;
            //dismiss do alert
            [_viewLoading setHidden:YES];
        }
    });
    
}


-(void) receiveJSONError:(NSNotification *) n
{
    _errorJSON = YES;
}









#pragma mark - botões para a filtragem do explore

- (IBAction)bDistrictsClicked:(id)sender {
    IGEOSearchQueryBuilder * sqb = [IGEOSearchQueryBuilder sharedEntitySearchQueryBuilder];
    
    sqb.queryType = kDistrict;
    
    @try{
        [self performSegueWithIdentifier:@"showPlacesList" sender:  sqb];
    }
    @catch(NSException *err){
        
    }
}


- (IBAction)bCouncilsClicked:(id)sender {
    IGEOSearchQueryBuilder * sqb = [IGEOSearchQueryBuilder sharedEntitySearchQueryBuilder];
    
    if(sqb.districtID==-1){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"SELECT_DISTRICT_MESSAGE"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        return;
    }
    
    sqb.queryType = KCouncil;
    
    @try {
        [self performSegueWithIdentifier:@"showPlacesList" sender:  sqb];
    }
    @catch(NSException *err){
        
    }
}


- (IBAction)bParishesClicked:(id)sender {
    IGEOSearchQueryBuilder * sqb = [IGEOSearchQueryBuilder sharedEntitySearchQueryBuilder];
    
    //NSLog(@"councilID = %d,",sqb.councilID);
    
    if(sqb.councilID==-1){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"SELECT_COUNCIL_MESSAGE"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        return;
    }
    
    sqb.queryType = kParish;
    
    @try {
        [self performSegueWithIdentifier:@"showPlacesList" sender:  sqb];
    }
    @catch(NSException *err){
        
    }
}


- (IBAction)bSearchClicked:(id)sender {
    
    IGEOSearchQueryBuilder * sqb = [IGEOSearchQueryBuilder sharedEntitySearchQueryBuilder];
    
    if(sqb.councilID==-1){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"SELECT_COUNCIL_MESSAGE"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
        return;
    }
    
    _bSearchClicked = YES;
    [self performSegueWithIdentifier:@"gotoOptions" sender:self];
    
    //NSLog(@"ine = %@",[IGEODataManager getIne]);
    
}






/**
 Obtém as configurações do ConfigsManager para este ecrã e aplica-os nas views respetivas.
 */
-(void) applyConfigs
{
    [_tTitle setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_BLACK"] size:38]];
    [_tSubtitle setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:14]];
    [_tNearMe setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_LIGHT"] size:15]];
    [_tSources setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_LIGHT"] size:15]];
    [_tExplore setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_LIGHT"] size:15]];
    [_bSearch.titleLabel setFont:[UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_LIGHT"] size:15]];
    
    
    //header
    [_topView setImage:[UIImage imageNamed:[IGEOConfigsManager getTopImage]]];
    
    NSArray *icons = [IGEOConfigsManager getHomeIcons];
    NSArray *clickedIcons = [IGEOConfigsManager getHomeIconsClicked];
    
    //imagens dos botões não clicados
    [_bSourcesList setImage:[UIImage imageNamed:[icons objectAtIndex:0]] forState:UIControlStateNormal];
    [_bNearMe setImage:[UIImage imageNamed:[icons objectAtIndex:1]] forState:UIControlStateNormal];
    [_bExplore setImage:[UIImage imageNamed:[icons objectAtIndex:2]] forState:UIControlStateNormal];
    
    //imagens de clique nos botões
    [_bSourcesList setImage:[UIImage imageNamed:[clickedIcons objectAtIndex:0]] forState:UIControlStateHighlighted];
    [_bNearMe setImage:[UIImage imageNamed:[clickedIcons objectAtIndex:1]] forState:UIControlStateHighlighted];
    [_bExplore setImage:[UIImage imageNamed:[clickedIcons objectAtIndex:2]] forState:UIControlStateHighlighted];
    
    
    //tornar a navigationbar transparente
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    self.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    
    
    //fundo do título da fonte
    [_tSubtitle setBackgroundColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppColor] alpha:1.0f]];
    
    
    //título da app
    [_tTitle setText:[IGEOConfigsManager getAppTitle]];
    _tTitle.shadowColor = [UIColor blackColor];
    _tTitle.shadowOffset = CGSizeMake(1,1);
    
    //Alterado para permitir imageNamed ou imageWithContentsOfFile
    NSString *urlBg = [IGEOConfigsManager getBackgroundImageForSource:@"-1"];
    if([urlBg hasPrefix:@"/"]){
        [_bgImageView setImage:[UIImage imageWithContentsOfFile:urlBg]];
    }
    else {
        [_bgImageView setImage:[UIImage imageNamed:urlBg]];
    }
    
}




#pragma mark - click no back da loadingView

- (IBAction)bBackLoadingViewClicked:(id)sender {
    [self backFromSourcesList];
    _errorJSON = NO;
    _threadGetSources = [[NSThread alloc] initWithTarget:self selector:@selector(getSourcesList) object:nil];
    [_threadGetSources start];
}






@end
