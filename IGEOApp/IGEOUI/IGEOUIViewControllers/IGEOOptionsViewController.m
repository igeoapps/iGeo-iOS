//
//  IGEOOptionsViewController.m
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOOptionsViewController.h"
#import "IGEOMainViewController.h"
#import "IGEOJSONServerReader.h"
#import "IGEODataManager.h"
#import "IGEOConfigsManager.h"
#import "IGEOLocationManager.h"
#import "IGEOUtils.h"
#import "IGEOCategoryListCell.h"
#import "IGEOMapViewController.h"
#import "IGEOListViewController.h"

@interface IGEOOptionsViewController ()

@property (nonatomic, strong) UIAlertView *alert;

@property (nonatomic) BOOL categoriesReceived;
@property (nonatomic) BOOL  error;
@property (nonatomic, strong) NSThread *threadGetCategories;
@property (nonatomic, strong) NSMutableDictionary *dictCategoriesPosition;

@end

@implementation IGEOOptionsViewController

//Constantes uilizadas para redimensionamento das view's
static const float SCREEN_HEIGHT_3_5 = 480.0f;
static const float SCREEN_HEIGHT_4_0 = 568.0f;
static const float BACK_WIDTH = 44.0f;
static const float BACK_HEIGHT = 33.0f;
static const float PADDING_BOTTON = 20.0f;
//--

@synthesize bInfo = _bInfo;
@synthesize fromExplore = _fromExplore;
@synthesize alert = _alert;
@synthesize bBack = _bBack;
@synthesize listOptions1 = _listOptions1;
@synthesize listOptions2 = _listOptions2;
@synthesize tSubtitle = _tSubtitle;
@synthesize tSelectCategories = _tSelectCategories;
@synthesize topView = _topView;
@synthesize isStartingLocationNow = _isStartingLocationNow;
@synthesize loadingView = _loadingView;
@synthesize loadingBackButton = _loadingBackButton;
@synthesize mainContainerView = _mainContainerView;
@synthesize tloadingMessage = _tloadingMessage;

@synthesize categoriesReceived = _categoriesReceived;
@synthesize error = _error;

//Thread utilizada para o carregamento das categorias
@synthesize threadGetCategories = _threadGetCategories;
//Dicionário que associa a cada categoria a sua posição na lista
@synthesize dictCategoriesPosition = _dictCategoriesPosition;




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
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    //aqui estamos a redimensionar a view principal quando estamos num ecrã de 3.5''
    if(screenHeight<SCREEN_HEIGHT_4_0){
        CGRect r = _mainContainerView.frame;
        r.size.height = SCREEN_HEIGHT_3_5 - PADDING_BOTTON;
        [_mainContainerView setFrame:r];
    }
    
    //aplica as configurações
    [self applyConfigs];
    
    //Deteção de gestos
    UISwipeGestureRecognizer * recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myDownAction:)];
    [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:recognizerDown];
    
    //back personalisado
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, BACK_WIDTH, BACK_HEIGHT)];
    [backButton addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    if(!_isStartingLocationNow){
        if(!_fromExplore && [[IGEOLocationManager sharedLocationManager] actualLocation]==nil && !_error){
            _error = YES;
            
            [_threadGetCategories cancel];
            
            [_loadingView setHidden:YES];
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_LOCATION"]
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else if(!_fromExplore && [[IGEOLocationManager sharedLocationManager] actualLocation].coordinate.latitude<=0.0f && !_error){
            _error = YES;
            
            [_threadGetCategories cancel];
            
            [_loadingView setHidden:YES];
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_LOCATION"]
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else {
            // Lançar a thread para obtenção dos dados
            _threadGetCategories = [[NSThread alloc] initWithTarget:self selector:@selector(getCategoriesList) object:nil];
            [_threadGetCategories start];
        }
    }
    
    else {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                          target: self
                                                        selector: @selector(performThreadAsync:)
                                                        userInfo: nil
                                                         repeats: NO];
        
        timer = nil;
    }
    
    //NSLog(@"LATUTUDE = %f",[[IGEOLocationManager sharedLocationManager] actualLocation].coordinate.latitude);
    
    //imagem dos clicks nos botões
    [_bBack setImage:[UIImage imageNamed:@"back_click_new"] forState:UIControlStateHighlighted];
    [_bInfo setImage:[UIImage imageNamed:@"info_click"] forState:UIControlStateHighlighted];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    self.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    
    //dado que estamos a usar duas listas em paralelo, aqui sempre que aplicamos algo a uma das listas temos de aplicar nas duas
    [_listOptions1 setBounces:NO];
    [_listOptions2 setBounces:NO];
    
    [_listOptions1 setHidden:YES];
    [_listOptions2 setHidden:YES];
    
    [_bOk setBackgroundImage:[IGEOUtils imageWithColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f]] forState:UIControlStateHighlighted];
    [_bOkList setBackgroundImage:[IGEOUtils imageWithColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f]] forState:UIControlStateHighlighted];
    
    [_tSubtitle setText:[IGEODataManager actualSource].sourcename];
    
    //coloca o pading no nome da fonte
    CGRect r = _tSubtitle.frame;
    int initualWidth = r.size.width;
    CGSize s;
    r.size.width = [_tSubtitle sizeThatFits:s].width + 15;
    r.origin.x -= (r.size.width - initualWidth)/2;
    [_tSubtitle setFrame:r];
    
    [_tloadingMessage setText:[IGEOUtils getStringForKey:@"LOADING_CATEGORIES"]];
}







-(void) performThreadAsync:(NSTimer *) t
{
    if(!_fromExplore && [[IGEOLocationManager sharedLocationManager] actualLocation]==nil && !_error){
        _error = YES;
        
        [_threadGetCategories cancel];
        
        //mensagem de erro a dizer que não temos acesso à localização
        if(_alert!=nil)
            [_alert dismissWithClickedButtonIndex:0 animated:YES];
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_LOCATION"]
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    }
    else if(!_fromExplore && [[IGEOLocationManager sharedLocationManager] actualLocation].coordinate.latitude<=0.0f && !_error){
        _error = YES;
        
        [_threadGetCategories cancel];
        
        //mensagem de erro a dizer que não temos acesso à localização
        if(_alert!=nil)
            [_alert dismissWithClickedButtonIndex:0 animated:YES];
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"NO_LOCATION"]
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    }
    else {
        // Lançar a thread para obtenção dos dados
        _threadGetCategories = [[NSThread alloc] initWithTarget:self selector:@selector(getCategoriesList) object:nil];
        [_threadGetCategories start];
    }
}





-(void) viewDidUnload
{
    
    //remover os observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //cancela a thread que obtem as categorias caso ela esteja a ser executada
    [_threadGetCategories cancel];
    _threadGetCategories = nil;
    
    //limpar as categorias ao fazer back
    [IGEODataManager clearCurrentFilterCategories];
    
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //adicionar o observer para receber o resultado das listas
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFinishLoadCategories:)
                                                 name:@"FinishLoadCategories"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveJSONErrorCategories:)
                                                 name:@"JSONErrorCategories"
                                               object:nil];
}



-(void) viewWillDisappear:(BOOL)animated
{
    if(_threadGetCategories!=nil){
        if([_threadGetCategories isExecuting]){
            [_threadGetCategories cancel];
        }
        
        _threadGetCategories = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"backHome"]){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        IGEOMainViewController *vc = (IGEOMainViewController *) segue.destinationViewController;
        [vc setSourcesExists:YES];
        
        if(_fromExplore)
            [vc setBackExplore:YES];
        
        vc = nil;
    }
    else if([segue.identifier isEqualToString:@"showMap"]){
        IGEOMapViewController *vc = (IGEOMapViewController *) segue.destinationViewController;
        [vc setFromExplore:_fromExplore];
        vc = nil;
    }
    else if([segue.identifier isEqualToString:@"showList"]){
        IGEOListViewController *vc = (IGEOListViewController *) segue.destinationViewController;
        [vc setFromExplore:_fromExplore];
        vc = nil;
    }
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self popVC:nil];
}













#pragma mark - métodos do swipe

-(void) popVC:(UIButton *) b
{
    [self myDownAction:nil];
}


/**
 Neste caso na ação de down do swipe vamos fazer voltar para a home fazendo pop do viewcontroller.
 */
-(void) myDownAction:(UISwipeGestureRecognizer *) r
{
    //limpar as categorias ao fazer back
    [IGEODataManager clearCurrentFilterCategories];
    self.title = @"";
    self.navigationController.viewControllers = [NSArray arrayWithObjects:self, nil];
    [self performSegueWithIdentifier:@"backHome" sender:self];
    
}









#pragma mark - click nos botões

- (IBAction)bInfoClicked:(id)sender {
}


- (IBAction)bBackClicked:(id)sender {
    //limpar as categorias ao fazer back
    [IGEODataManager clearCurrentFilterCategories];
    [self popVC:nil];
}


- (IBAction)bOKClicked:(id)sender {
    if([IGEODataManager getActualCategoriesListActualFilterIDS] == nil){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"CATEGORIES_SELECT"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    }
    else if([[IGEODataManager getActualCategoriesListActualFilterIDS] count] == 0){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"CATEGORIES_SELECT"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self performSegueWithIdentifier:@"showMap" sender:self];
    }
}


- (IBAction)bOkListClicked:(id)sender {
    
    if([IGEODataManager getActualCategoriesListActualFilterIDS] == nil){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"CATEGORIES_SELECT"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    }
    else if([[IGEODataManager getActualCategoriesListActualFilterIDS] count] == 0){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"CATEGORIES_SELECT"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self performSegueWithIdentifier:@"showList" sender:self];
    }
    
}










#pragma mark - notifications

/**
 Aqui vamos tomar as ações necessárias após a obtenção das categroias.
 */
-(void) receiveFinishLoadCategories:(NSNotification *) n
{
    if(_categoriesReceived || _error)
        return;
    
    //NSLog(@"Catgories received!");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //como estamos a utilizar uma view personalizada para o loading aqui iremos apresenta-la
        [_loadingView setHidden:YES];
        
        if([IGEOJSONServerReader temporaryCategories]==nil){
            if(_error)
                return;
            
            _error = YES;
            
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"OPTIONS_DONT_EXISTS_ALERT_TITLE"]
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else if([[IGEOJSONServerReader temporaryCategories] count]==0){
            if(_error)
                return;
            
            _error = YES;
            
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"OPTIONS_DONT_EXISTS_ALERT_TITLE"]
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else {
            //Caso a operação de obtenção dos items tenha sido bem sucedida, vamos construir as listas
            //Para a construção da lista temos que, os items de indice par do array de categorias será carregado na
            //lista da esquerda e os items pares na lista da direita.
            NSArray *tmpArray = [IGEOJSONServerReader temporaryCategories];
            NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
            for(IGEOCategory *c in tmpArray){
                [tmpDict setObject:c forKey:c.categoryID];
            }
            [[IGEODataManager actualSource] setCategoryDictionary:tmpDict];
            
            tmpArray = nil;
            tmpDict = nil;
            
            [_listOptions1 reloadData];
            [_listOptions2 reloadData];
            [_listOptions1 setHidden:NO];
            if([[IGEOJSONServerReader temporaryCategories] count]>1)
                [_listOptions2 setHidden:NO];
        }
    });
    
}


/**
 Método chamado quando ocorre um erro na obtenção das categorias através do servidor.
 */
-(void) receiveJSONErrorCategories:(NSNotification *) n
{
    if(_categoriesReceived || _error)
        return;
    
    _categoriesReceived = YES;
    
    //NSLog(@"Error on JSON!");
    
    if(_alert!=nil)
        [_alert dismissWithClickedButtonIndex:0 animated:YES];
    [_loadingView setHidden:YES];
    _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"OPTIONS_ERROR_ALERT_TITLE"]
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                              otherButtonTitles: nil];
    [_alert show];
}




















#pragma mark - sources list

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numCategories = (int) [[IGEODataManager getCategoriesForSourceID:[IGEODataManager actualSource].sourceID] count];
    
    //Dado estarmos a trabalhar com duas tableView's em paralelo temos de ter em conta essa questão neste método e no
    //método de seleção dos items.
    if(tableView==_listOptions1){
        if(numCategories%2==0){
            return (int)(numCategories/2);
        }
        else {
            return (((int)(numCategories/2)) + 1);
        }
    }
    else if(tableView==_listOptions2){
        if(numCategories%2==0){
            return (int)(numCategories/2);
        }
        else {
            return (((int)(numCategories/2)) - 0);
        }
        
        return 1;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"IGEOCategoryListCell";
    
    IGEOCategoryListCell *cell = (IGEOCategoryListCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IGEOCategoryListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //substituir
    //obter a source pela posição
    //aqui dado estarmos a trabalhar com duas TableView's em simultâneo temos de ter isso em conta
    //na colocação dos dads nos items
    int pos = 0;
    if(tableView==_listOptions1){
        pos = (int) indexPath.row*2;
    }
    else if(tableView==_listOptions2){
        pos = (int) (indexPath.row*2) + 1;
    }
    IGEOCategory *c = [[IGEODataManager getCategoriesForSourceID:[IGEODataManager actualSource].sourceID] objectAtIndex:pos];
    //
    cell.title.text = c.categoryName;
    
    
    cell.icon.image = [UIImage imageNamed:
                       [IGEOConfigsManager getIconForSource:[IGEODataManager actualSource].sourceID
                                               AndCategory:c.categoryID
                        ]
                       ];
    
    //Vamos colocar a imagem da categoria no item da lista, através de um ficheiro na pasta da App se
    //o nome se iniciar pela string "/", ou atraves dos ficheiros contidos no projeto caso contrário.
    NSString *urlIcon = [IGEOConfigsManager getIconForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID];
    if([urlIcon hasPrefix:@"/"]){
        cell.icon.image = [UIImage imageWithContentsOfFile:urlIcon];
    }
    else {
        cell.icon.image = [UIImage imageNamed:urlIcon];
    }
    
    
    [cell.title setUserInteractionEnabled:NO];
    [cell.icon setUserInteractionEnabled:NO];
    
    //limpar cor de fundo para nao ficar opaco
    cell.backgroundColor = [UIColor clearColor];
    [tableView setBackgroundColor:[UIColor clearColor]];
    
    //definir a view de seleção
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
    bgView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    cell.selectedBackgroundView = bgView;
    cell.backgroundView = bgView;
    
    //retirar o separador entre celulas
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    //se a categoria pertence à lista de categorias que estão selecionadas
    //vamos coloca-la com o icone selecionada
    if([IGEODataManager getCurrentFilterCategories] != nil){
        if([[IGEODataManager getCurrentFilterCategories] containsObject:c]){
            cell.icon.image = [UIImage imageNamed:
                               [IGEOConfigsManager getIconForSource:[IGEODataManager actualSource].sourceID
                                               AndCategorySelected:c.categoryID
                                ]
                               ];
        }
    }
    
    
    //adicionar ao hashmap das categorias
    if(_dictCategoriesPosition == nil)
        _dictCategoriesPosition = [[NSMutableDictionary alloc] init];
    [_dictCategoriesPosition setObject:c forKey:[NSNumber numberWithInt:pos]];
    //--
    
    return cell;
}


/**
 Este método permite que ao fazermos scroll numa das tableView's façamos em simultâneo na tableView ao lado desta.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    UITableView *slaveTable = nil;
    
    if (_listOptions1 == scrollView) {
        slaveTable = _listOptions2;
    } else if (_listOptions2 == scrollView) {
        slaveTable = _listOptions1;
    }
    
    [slaveTable setContentOffset:scrollView.contentOffset];
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int pos = 0;
    if(tableView==_listOptions1){
        pos = (int) indexPath.row*2;
    }
    else if(tableView == _listOptions2){
        pos = (int) (indexPath.row*2)+1;
    }
    
    //obter do hashmap;
    IGEOCategory *c = [_dictCategoriesPosition objectForKey:[NSNumber numberWithInt:pos]];
    
    //se a categoria não foi selecionada
    if(![[IGEODataManager getActualCategoriesListActualFilterIDS] containsObject:c.categoryID]){
        [IGEODataManager addActualCategory:c];
        IGEOCategoryListCell *cell = (IGEOCategoryListCell *) [(tableView==_listOptions1 ? _listOptions1 : _listOptions2) cellForRowAtIndexPath:indexPath];
        
        
        //Vamos colocar a imagem da categoria no item da lista, através de um ficheiro na pasta da App se
        //o nome se iniciar pela string "/", ou atraves dos ficheiros contidos no projeto caso contrário.
        NSString *urlIcon = [IGEOConfigsManager getIconForSource:[IGEODataManager actualSource].sourceID AndCategorySelected:c.categoryID];
        if([urlIcon hasPrefix:@"/"]){
            cell.icon.image = [UIImage imageWithContentsOfFile:urlIcon];
        }
        else {
            cell.icon.image = [UIImage imageNamed:urlIcon];
        }
        
        
        cell = nil;
    }
    
    //se a categoria já foi selecionada
    else {
        [IGEODataManager removeActualCategory:c.categoryID];
        IGEOCategoryListCell *cell = (IGEOCategoryListCell *) [(tableView==_listOptions1 ? _listOptions1 : _listOptions2) cellForRowAtIndexPath:indexPath];
        
        
        //Vamos colocar a imagem da categoria no item da lista, através de um ficheiro na pasta da App se
        //o nome se iniciar pela string "/", ou atraves dos ficheiros contidos no projeto caso contrário.
        NSString *urlIcon = [IGEOConfigsManager getIconForSource:[IGEODataManager actualSource].sourceID AndCategory:c.categoryID];
        if([urlIcon hasPrefix:@"/"]){
            cell.icon.image = [UIImage imageWithContentsOfFile:urlIcon];
        }
        else {
            cell.icon.image = [UIImage imageNamed:urlIcon];
        }
        
        
        cell = nil;
    }
    
    c = nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}










#pragma mark - loading back button click

- (IBAction)loadingBackButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self popVC:nil];
}









#pragma mark - obtenção de dados

/**
 Obtém a lista de categorias. A consulta que é feita ao servidor depende do facto de virmos do explorer ou do perto de mim.
 */
-(void) getCategoriesList
{
    
    if(_fromExplore){
        [IGEODataManager getCategoriesListActualSourceInSearchLocation];
    }
    else {
        [IGEODataManager getCategoriesListActualSourceInLocation:[[IGEOLocationManager sharedLocationManager] actualLocation]];
    }
    
}






/**
 Obtém as configs do Configsmanager e aplica-as nas view's correspondentes.
 */
-(void) applyConfigs
{
    [_tSelectCategories setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:20]];
    [_tSubtitle setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:14]];
    [_bOk.titleLabel setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_LIGHT"] size:15]];
    [_bOkList.titleLabel setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_LIGHT"] size:15]];
    
    [_topView setImage:[UIImage imageNamed:[IGEOConfigsManager getTopImage]]];
    
    [_tSubtitle setBackgroundColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppColor] alpha:1.0f]];
}

@end
