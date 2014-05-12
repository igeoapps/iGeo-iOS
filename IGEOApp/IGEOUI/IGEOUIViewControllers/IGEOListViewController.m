//
//  IGEOListViewController.m
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOListViewController.h"
#import "IGEOConfigsManager.h"
#import "IGEODataManager.h"
#import "IGEODataItem.h"
#import "IGEODataItemListCell.h"
#import "IGEOUtils.h"
#import "IGEOLocationManager.h"
#import "IGEOMapViewController.h"
#import "IGEODataItemTitleListCell.h"
#import "IGEODetailsViewController.h"

@interface IGEOListViewController ()

@property (nonatomic, strong) UIAlertView *alert;

@property (nonatomic) BOOL dataItemsReceived;
@property (nonatomic) BOOL  error;
@property (nonatomic, strong) NSThread *threadGetDataItemsMap;
@property (nonatomic) BOOL searchClicked;
@property (nonatomic, strong) NSMutableArray *dataItemsWithCategories;
@property (nonatomic) BOOL hadMoreItems;
@property (nonatomic) int actualLastPos;
@property (nonatomic, strong) NSString *lastcatID;
@property (nonatomic) BOOL seeMoreClicked;
@property (nonatomic, strong) NSMutableArray *changeCategoryArray;
@property (nonatomic, strong) NSString *selectedID;

@end

@implementation IGEOListViewController

//Constantes utilizadas no redimensionamento de view's
static const float SEARCH_BOX_PADDING = 20.0f;
static const float HEADER_VIEW_SIZE = 36.0f;
static const float SUBTITLE_PADDING = 15.0f;
static const float SEE_MORE_BUTTON_RADIUS = 15.0f;
static const float SEE_MORE_BUTTON_LEFT_PADDING = 10.0f;
static const float SEE_MORE_BUTTON_RIGHT_PADDING = 45.0f;
static const float SEE_MORE_BUTTON_TOP_PADDING = 5.0f;
static const float SEE_MORE_BUTTON_DELTA_WITH = 30.0f;
static const float CELL_TNAME_TOP_PADDING = 10.0f;

@synthesize bBack = _bBack;
@synthesize bHome = _bHome;
@synthesize bMap = _bMap;
@synthesize tSearch = _tSearch;
@synthesize bSearch = _bSearch;
@synthesize bgImageView = _bgImageView;
@synthesize tableDataItems = _tableDataItems;
@synthesize fromExplore = _fromExplore;
@synthesize fromMap = _fromMap;
@synthesize tResults = _tResults;
@synthesize tSubtitle = _tSubtitle;
@synthesize loadingView = _loadingView;
@synthesize bBackLoadingView = _bBackLoadingView;
@synthesize tLoadingMessage = _tLoadingMessage;

//indica se já foram recebidos os items
@synthesize dataItemsReceived = _dataItemsReceived;
//indica se ocorreu um erro
@synthesize error = _error;
//thread utilizada para a obtenção de items. A definição de uma thread à qual temos acesso
//permite que quando façamos back cancelemos esse carregamento
@synthesize threadGetDataItemsMap = _threadGetDataItemsMap;

@synthesize searchClicked = _searchClicked;
@synthesize dataItemsWithCategories = _dataItemsWithCategories;

//indica se existem mais itens a carregar na lista
@synthesize hadMoreItems = _hadMoreItems;

//ultima posição da lista de items existente carregada na tableview
@synthesize actualLastPos = _actualLastPos;

//ID da categoria do último item carregado
@synthesize lastcatID = _lastcatID;

@synthesize seeMoreClicked = _seeMoreClicked;

//Neste array estão contidos os índices dos items nos quais a categoria é alterada. Através disto
//podemos colocar nesses mesmos indexes mais um item que contém o título da categoria seguinte.
@synthesize changeCategoryArray = _changeCategoryArray;
@synthesize selectedID = _selectedID;

static BOOL reloadData;



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
    
    _actualLastPos = 0;
    _lastcatID = nil;
    
    _dataItemsWithCategories = [[NSMutableArray alloc] init];
    
    // Lançar a thread para obtenção dos dados
    _threadGetDataItemsMap = [[NSThread alloc] initWithTarget:self selector:@selector(getDataItemsListMap) object:nil];
    [_threadGetDataItemsMap start];
    
    //altera a cor da barra de notificações
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    self.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    
    
    [_tableDataItems setBounces:NO];
    [_tableDataItems setHidden:YES];
    
    _tableDataItems.contentInset = UIEdgeInsetsMake(-HEADER_VIEW_SIZE, 0, 0, 0);
    
    _tSearch.delegate = self;
    
    [_bgImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *closeKeyboardGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboardHandler:)];
    closeKeyboardGestureRecognizer.numberOfTapsRequired = 1;
    [_bgImageView addGestureRecognizer:closeKeyboardGestureRecognizer];
    
    [_tSubtitle setText:[IGEODataManager actualSource].sourcename];
    
    CGRect r = _tSubtitle.frame;
    int initualWidth = r.size.width;
    CGSize s;
    r.size.width = [_tSubtitle sizeThatFits:s].width + SUBTITLE_PADDING;
    r.origin.x -= (r.size.width - initualWidth);
    [_tSubtitle setFrame:r];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEARCH_BOX_PADDING, SEARCH_BOX_PADDING)];
    _tSearch.rightView = paddingView;
    _tSearch.rightViewMode = UITextFieldViewModeAlways;
    paddingView = nil;
    
    [_tLoadingMessage setText:[IGEOUtils getStringForKey:@"LOADING_LIST"]];
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
                                             selector:@selector(receiveFinishLoadDataItemsMap:)
                                                 name:@"FinishLoadDataItems"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveJSONErrorDataItemsMap:)
                                                 name:@"JSONErrorDataItemsMap"
                                               object:nil];
    
    if(_tableDataItems!=nil){
        for (NSIndexPath *indexPath in _tableDataItems.indexPathsForSelectedRows) {
            [_tableDataItems deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    
    [self.view endEditing:YES];
    
}


-(void) viewDidUnload
{
    if(!_fromMap)
        [IGEODataManager clearKeywords];
    
    [super viewDidUnload];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}




-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showMapFromList"]){
        IGEOMapViewController *vc = (IGEOMapViewController *) segue.destinationViewController;
        [vc setFromList:YES];
    }
    else if([segue.identifier isEqualToString:@"showDetailsFromList"]){
        IGEODetailsViewController *vc = (IGEODetailsViewController *) segue.destinationViewController;
        [vc setItemID:_selectedID];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self bBackClicked:nil];
}










#pragma mark - métodos de acesso às variaveis estáticas

+(BOOL) getReloadData
{
    return reloadData;
}


+(void) setReloadData:(BOOL) r
{
    reloadData = r;
}








#pragma mark - cliques nos botões

- (IBAction)bBackClicked:(id)sender {
    if(_threadGetDataItemsMap != nil){
        if([_threadGetDataItemsMap isExecuting])
            [_threadGetDataItemsMap cancel];
        
        _threadGetDataItemsMap = nil;
    }
    
    if(_alert != nil)
        [_alert dismissWithClickedButtonIndex:0 animated:YES];
    
    if(_searchClicked && _fromMap){
        [IGEOMapViewController setReloadData:YES];
    }
    
    if(!_fromMap)
        [IGEODataManager clearKeywords];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)bHomeClicked:(id)sender {
    [IGEODataManager clearCurrentFilterCategories];
    [IGEODataManager clearKeywords];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [IGEODataManager clearCurrentFilterCategories];
    [IGEODataManager clearTemporaryDataItems];
    
    if(_threadGetDataItemsMap != nil){
        if([_threadGetDataItemsMap isExecuting])
            [_threadGetDataItemsMap cancel];
        
        _threadGetDataItemsMap = nil;
    }
    
    if(_alert != nil)
        [_alert dismissWithClickedButtonIndex:0 animated:YES];
    
    [self performSegueWithIdentifier:@"backHomeFromList" sender:self];
}


- (IBAction)bMapClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //se clicamos no botão do mapa vamos cancelar a thread que carrega os items na lista
    if(_threadGetDataItemsMap != nil){
        if([_threadGetDataItemsMap isExecuting])
            [_threadGetDataItemsMap cancel];
        
        _threadGetDataItemsMap = nil;
    }
    
    if(_alert != nil)
        [_alert dismissWithClickedButtonIndex:0 animated:YES];
    
    if(_searchClicked && _fromMap){
        [IGEOMapViewController setReloadData:YES];
    }
    
    if(!_fromMap)
        [self performSegueWithIdentifier:@"showMapFromList" sender:self];
    else
        [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)bSearchClicked:(id)sender {
    [self.view endEditing:YES];
    
    _searchClicked = YES;
    _hadMoreItems = NO;
    _actualLastPos = 0;
    _lastcatID = nil;
    if(_dataItemsWithCategories!=nil)
        [_dataItemsWithCategories removeAllObjects];
    
    if(_changeCategoryArray!=nil){
        [_changeCategoryArray removeAllObjects];
    }
    
    [IGEODataManager clearTemporaryDataItems];
    [IGEOJSONServerReader clearTemporarydataItems];
    
    if(_tSearch.text!=nil){
        //mostrar o alert
        [_loadingView setHidden:NO];
        
        _dataItemsWithCategories = [[NSMutableArray alloc] init];
        
        // Lançar a thread para obtenção dos dados
        _threadGetDataItemsMap = [[NSThread alloc] initWithTarget:self selector:@selector(getDataItemsListMapFiltered) object:nil];
        [_threadGetDataItemsMap start];
    }
}


//clique no botão "Ver mais"
- (IBAction)seeMoreClicked:(id)sender {
    _seeMoreClicked = YES;
    
    [self seeMore];
}











#pragma mark - "ver mais" da lista de items

-(void) seeMore
{
    //reload da tabela
    NSArray *tmpArray = [IGEOJSONServerReader temporaryDataItems];
    int i= (int) [_dataItemsWithCategories count], coutArrayItems=0;
    int contItems = 0;
    _hadMoreItems = NO;
    IGEOGenericDataItem *di = nil;
    for(coutArrayItems=_actualLastPos;coutArrayItems<[tmpArray count];coutArrayItems++){
        di = (IGEOGenericDataItem *) [tmpArray objectAtIndex:coutArrayItems];
        [[IGEODataManager localHashMapDataItems] setObject:di forKey:di.itemID];
        
        if(_lastcatID==nil){
            IGEOGenericDataItem *diCat = [[IGEOGenericDataItem alloc] init];
            diCat.itemID = @"-1";
            diCat.title = ((IGEOCategory *) [[[IGEODataManager actualSource] categoryDictionary] objectForKey:di.categoryID]).categoryName;
            diCat.categoryID = di.categoryID;
            [_dataItemsWithCategories addObject:diCat];
            
            _lastcatID = di.categoryID;
            
            if(_changeCategoryArray==nil)
                _changeCategoryArray = [[NSMutableArray alloc] init];
            [_changeCategoryArray addObject:[[NSNumber alloc] initWithInt:i+1]];
            
            i++;
        }
        else if(![di.categoryID isEqualToString:_lastcatID]){
            IGEOGenericDataItem *diCat = [[IGEOGenericDataItem alloc] init];
            diCat.itemID = @"-1";
            diCat.title = ((IGEOCategory *) [[[IGEODataManager actualSource] categoryDictionary] objectForKey:di.categoryID]).categoryName;
            diCat.categoryID = di.categoryID;
            [_dataItemsWithCategories addObject:diCat];
            
            _lastcatID = di.categoryID;
            
            if(_changeCategoryArray==nil)
                _changeCategoryArray = [[NSMutableArray alloc] init];
            [_changeCategoryArray addObject:[[NSNumber alloc] initWithInt:i]];
            
            i++;
        }
        
        [_dataItemsWithCategories addObject:di];
        
        i++;
        contItems++;
        
        
        //Condição de paragem para a paginação
        if(coutArrayItems>=_actualLastPos + 10){
            _hadMoreItems = YES;
            break;
        }
    }
    
    _actualLastPos+=contItems;
    
    [IGEODataManager addTemporaryDataItems:[tmpArray mutableCopy]];
    
    //reload da tabela
    [_tableDataItems reloadData];
    
    [_tableDataItems setHidden:NO];
    
    [_tResults setText:[NSString stringWithFormat:[IGEOUtils getStringForKey:@"LIST_RECORDS_NUMBER"], (unsigned long)[tmpArray count]]];
    
    tmpArray = nil;
    
    if([_dataItemsWithCategories count]==0){
        _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"LIST_DONT_EXISTS_ALERT_TITLE"]
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                  otherButtonTitles: nil];
        [_alert show];
    }
    
}













#pragma mark - dataitems list

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataItemsWithCategories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}


- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}


- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}


//Aqui estamos a retirar o header para que a lista comece no primeiro item e não exista um padding de topo
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sec = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    [sec setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
    return sec;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"IGEODataItemListCell";
    
    //substituir
    //obter a fonte pela poisção
    IGEOGenericDataItem *di = [_dataItemsWithCategories objectAtIndex:indexPath.section];
    
    //Verifica se não estamos num item em que estamos a mudar de categoria.
    if(![_changeCategoryArray containsObject:[[NSNumber alloc] initWithInt:(int) indexPath.section]]){
        IGEODataItemListCell *cell = (IGEODataItemListCell *)[_tableDataItems dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IGEODataItemListCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.tName.text = di.title;
        if([di.categoryID isEqualToString:@"-1"]){
            di.textOrHTML = @"";
            cell.tSubtitle.text = @"";
        }
        else
            cell.tSubtitle.text = di.textOrHTML;
        
        
        //fontes
        [cell.tName setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_MEDIUM"] size:18]];
        [cell.tSubtitle setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:15]];
        //--
        
        //limpar cor de fundo para não ficar opaco
        cell.backgroundColor = [UIColor clearColor];
        
        [tableView setBackgroundColor:[UIColor clearColor]];
        
        //definir a view de seleção
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        bgView.backgroundColor = [IGEOUtils colorWithHexString:[[IGEOConfigsManager getAppConfigs] appColor] alpha:0.6f];
        cell.selectedBackgroundView = bgView;
        
        //retirar o separador entre celulas
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
        
        
        //Indica se estamos no último item do máximo de items a carregar e existem mais items
        //vamos adicionar como footer da tabela o botão "Ver mais"
        if(indexPath.section==[_dataItemsWithCategories count]-1 && _hadMoreItems){
            UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SEE_MORE_BUTTON_TOP_PADDING, _tableDataItems.frame.size.width, SEE_MORE_BUTTON_RIGHT_PADDING)];
            UIButton *seeMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [seeMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [seeMore setTitle:[IGEOUtils getStringForKey:@"SEE_MORE"] forState:UIControlStateNormal];
            [seeMore.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [seeMore setFrame:CGRectMake(SEE_MORE_BUTTON_LEFT_PADDING, 0.0, _tableDataItems.frame.size.width - SEE_MORE_BUTTON_DELTA_WITH, SEE_MORE_BUTTON_RIGHT_PADDING-3)];
            [seeMore setBackgroundColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
            seeMore.layer.cornerRadius = SEE_MORE_BUTTON_RADIUS;
            [seeMore addTarget:self action:@selector(seeMoreClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [seeMore.titleLabel setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_LIGHT"] size:15]];
            
            [bottomView addSubview:seeMore];
            
            [_tableDataItems setTableFooterView:bottomView];
            
            bottomView = nil;
            seeMore = nil;
        }
        else if(indexPath.section==[_dataItemsWithCategories count]-1){
            [_tableDataItems setTableFooterView:nil];
        }
        
        //se não existem mais items remove o footer
        if(!_hadMoreItems){
            UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            [_tableDataItems setTableFooterView:bottomView];
        }
        
        [cell.tName setUserInteractionEnabled:NO];
        [cell.tSubtitle setUserInteractionEnabled:NO];
        [cell.backgroundView setUserInteractionEnabled:YES];
        [cell setUserInteractionEnabled:YES];
        
        return cell;
    }
    
    //se estamos no item em que estamos a aterar a categoria
    else {
        //Vamos adicionar um item na lista onde colocaremos o título.
        IGEODataItemTitleListCell *cell = (IGEODataItemTitleListCell *)[_tableDataItems dequeueReusableCellWithIdentifier:@"IGEODataItemTitleListCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IGEODataItemTitleListCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        di.textOrHTML = @"";
        cell.tName.text = [di.title uppercaseString];
        [cell setBackgroundColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getColorForHTMLCategory:di.categoryID] alpha:1.0f]];
        
        [cell.tName setUserInteractionEnabled:NO];
        
        //limpar cor de fundo para nao ficar opaco
        [tableView setBackgroundColor:[UIColor clearColor]];
        
        //definir a view de seleção
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        bgView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        [bgView setAlpha:0.0f];
        cell.selectedBackgroundView = bgView;
        
        //retirar o separador entre celulas
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
        [cell.tName setFrame:CGRectMake(cell.tName.frame.origin.x, CELL_TNAME_TOP_PADDING, cell.tName.frame.size.width, cell.tName.frame.size.height)];
        
        [cell setUserInteractionEnabled:NO];
        
        return cell;
    }
    
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //apenas vamos permitir o clique se não estivermos num título de uma categoria
    if(![_changeCategoryArray containsObject:[[NSNumber alloc] initWithInt:(int) indexPath.section]]){
        IGEOGenericDataItem *di = (IGEOGenericDataItem *) [_dataItemsWithCategories objectAtIndex:indexPath.section];
        _selectedID = di.itemID;
        [self performSegueWithIdentifier:@"showDetailsFromList" sender:self];
        di = nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //neste caso o tamanho da celula depende de se estamos num título ou num item normal
    if(![_changeCategoryArray containsObject:[[NSNumber alloc] initWithInt:(int) indexPath.section]])
        return 90;
    else
        return 55;
}










#pragma mark - obtenção de dados

-(void) getDataItemsListMap
{
    
    if(!_fromMap){
        //se vimos do explore vamos pesquisar pelo ine
        if(_fromExplore){
            [IGEODataManager getListForSource:[IGEODataManager actualSource].sourceID AndCategoriesInSearchLocation:[IGEODataManager getActualCategoriesListActualFilterIDS]];
        }
        //se não vamos pesquisar através da localização atual
        else {
            [IGEODataManager getListForSource:[IGEODataManager actualSource].sourceID AndCategories:[IGEODataManager getActualCategoriesListActualFilterIDS] Near:[[IGEOLocationManager sharedLocationManager] actualLocation]];
        }
    }
    //se viemos do mapa, já não é necessário a obtenção dos dados pois eles já existem em cache
    else {
        [self receiveFinishLoadDataItemsMap:nil];
        [_loadingView setHidden:NO];
        [_tableDataItems setHidden:NO];
    }
    
}


//utilizado na pesquisa por palavras chave
-(void) getDataItemsListMapFiltered
{
    
    if(_fromExplore){
        [IGEODataManager getListForSource:[IGEODataManager actualSource].sourceID AndCategories:[IGEODataManager getActualCategoriesListActualFilterIDS] InSearchLocationFiltered:_tSearch.text];
    }
    else {
        [IGEODataManager getListForSource:[IGEODataManager actualSource].sourceID AndCategories:[IGEODataManager getActualCategoriesListActualFilterIDS] Near:[[IGEOLocationManager sharedLocationManager] actualLocation] Filtered:_tSearch.text];
    }
    
}








#pragma mark - notifications

//método chamado quando termina a obtenção dos items do DataSource
//É aqui que dependendo do resultado obtido vamos ou não carregar os items na lista.
-(void) receiveFinishLoadDataItemsMap:(NSNotification *) n
{
    if(_dataItemsReceived || _error)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_loadingView setHidden:YES];
        
        if([IGEOJSONServerReader temporaryCategories]==nil){
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"LIST_DONT_EXISTS_ALERT_TITLE"]
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else if([[IGEOJSONServerReader temporaryCategories] count]==0){
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"LIST_DONT_EXISTS_ALERT_TITLE"]
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else {
            if(!_seeMoreClicked){
                if(_dataItemsWithCategories!=nil)
                    [_dataItemsWithCategories removeAllObjects];
                
                _dataItemsWithCategories = [[NSMutableArray alloc] init];
                
                _lastcatID = nil;
                _actualLastPos = 0;
            }
            else {
                _seeMoreClicked = NO;
            }
            
            
            
            //reload da tabela
            //o carregamento da tabela é feito de forma a que sejam carregados um número máximo de items e a partir desse número
            //de items, iremos então colocar o botão "Ver mais". Quando clicamos no botão ver mais, iremos obter mais itens e colocá-los
            //na lista.
            NSArray *tmpArray = [IGEOJSONServerReader temporaryDataItems];
            [IGEODataManager clearTemporaryDataItems];
            int i=_actualLastPos, coutArrayItems=0;
            int contItems = 0;
            IGEOGenericDataItem *di = nil;
            for(coutArrayItems=0;coutArrayItems<[tmpArray count];coutArrayItems++){
                di = (IGEOGenericDataItem *) [tmpArray objectAtIndex:coutArrayItems];
                [[IGEODataManager localHashMapDataItems] setObject:di forKey:di.itemID];
                
                if(_lastcatID==nil){
                    IGEOGenericDataItem *diCat = [[IGEOGenericDataItem alloc] init];
                    diCat.itemID = @"-1";
                    diCat.title = ((IGEOCategory *) [[[IGEODataManager actualSource] categoryDictionary] objectForKey:di.categoryID]).categoryName;
                    diCat.categoryID = di.categoryID;
                    [_dataItemsWithCategories addObject:diCat];
                    
                    _lastcatID = di.categoryID;
                    
                    if(_changeCategoryArray==nil)
                        _changeCategoryArray = [[NSMutableArray alloc] init];
                    [_changeCategoryArray addObject:[[NSNumber alloc] initWithInt:i]];
                    
                    i++;
                    
                    diCat = nil;
                }
                else if(![di.categoryID isEqualToString:_lastcatID]){
                    IGEOGenericDataItem *diCat = [[IGEOGenericDataItem alloc] init];
                    diCat.itemID = @"-1";
                    diCat.title = ((IGEOCategory *) [[[IGEODataManager actualSource] categoryDictionary] objectForKey:di.categoryID]).categoryName;
                    diCat.categoryID = di.categoryID;
                    [_dataItemsWithCategories addObject:diCat];
                    
                    _lastcatID = di.categoryID;
                    
                    if(_changeCategoryArray==nil)
                        _changeCategoryArray = [[NSMutableArray alloc] init];
                    [_changeCategoryArray addObject:[[NSNumber alloc] initWithInt:i]];
                    
                    i++;
                    
                    diCat = nil;
                }
                
                [_dataItemsWithCategories addObject:di];
                
                i++;
                contItems++;
                
                
                //Condição de paragem para a paginação
                if(contItems>10){
                    _hadMoreItems = YES;
                    break;
                }
                
            }
            
            _actualLastPos+=contItems;
            
            [IGEODataManager addTemporaryDataItems:[tmpArray mutableCopy]];
            
            //reload da tabela
            [_tableDataItems reloadData];
            
            [_tableDataItems setHidden:NO];
            
            [_tResults setText:[NSString stringWithFormat:[IGEOUtils getStringForKey:@"LIST_RECORDS_NUMBER"], (unsigned long)[tmpArray count]]];
            
            tmpArray = nil;
            
            if([_dataItemsWithCategories count]==0){
                _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"LIST_DONT_EXISTS_ALERT_TITLE"]
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:[IGEOUtils getStringForKey:@"OK_TEXT"]
                                          otherButtonTitles: nil];
                [_alert show];
            }
            
            //NSLog(@"-- _actualLastPos = %d",_actualLastPos);
            
        }
    });
    
}


//Método chamado quando ocorre um erro na leitura dos items.
-(void) receiveJSONErrorDataItemsMap:(NSNotification *) n
{
    if(_dataItemsReceived || _error)
        return;
    
    _dataItemsReceived = YES;
    
    [_loadingView setHidden:YES];
    _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"LIST_ERROR_ALERT_TITLE"]
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                              otherButtonTitles: nil];
    [_alert show];
    
    [_tResults setText:[IGEOUtils getStringForKey:@"LIST_NO_RECORDS"]];
    
    [_tableDataItems setHidden:YES];
}








#pragma mark - métodos do textfielddeelegate

- (BOOL)textFieldShouldReturn:(UITextField *) textField
{
    [self bSearchClicked:nil];
    
    return YES;
}


- (void)closeKeyboardHandler:(UIGestureRecognizer*) tap
{
    [self.view endEditing:YES];
}









#pragma mark - métodos do IGEOConfigurable

/**
 Aqui vamos ler e aplicar as configurações para este ecrã do ConfigsManager 
 */
-(void) applyConfigs
{
    [_tSubtitle setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:14]];
    [_tResults setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:14]];
    
    [_bHome setImage:[UIImage imageNamed:@"home_new_click"] forState:UIControlStateHighlighted];
    [_bMap setImage:[UIImage imageNamed:@"mapa_click"] forState:UIControlStateHighlighted];
    [_bSearch setImage:[UIImage imageNamed:@"pesquisa_click"] forState:UIControlStateHighlighted];
    
    
    //Alterado para permitir imageNamed ou imageWithContentsOfFile
    NSString *urlBg = [IGEOConfigsManager getBackgroundRightImageForSource:[IGEODataManager actualSource].sourceID];
    if([urlBg hasPrefix:@"/"]){
        [_bgImageView setImage:[UIImage imageWithContentsOfFile:urlBg]];
    }
    else {
        [_bgImageView setImage:[UIImage imageNamed:urlBg]];
    }
    
    [_tSubtitle setBackgroundColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppColor] alpha:1.0f]];
    
    [_topView setBackgroundColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppColor] alpha:1.0f]];
    
    [_tSearch setBackgroundColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppColor] alpha:1.0f]];
    
    [_tResults setBackgroundColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppColor] alpha:1.0f]];
}




#pragma mark - clique no back da loadingview

- (IBAction)bBackLoadingViewClicked:(id)sender {
    [self bBackClicked:nil];
}



@end
