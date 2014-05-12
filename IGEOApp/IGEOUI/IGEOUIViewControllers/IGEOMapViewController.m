//
//  IGEOMapViewController.m
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOMapViewController.h"
#import "IGEODataManager.h"
#import "IGEOLocationManager.h"
#import <MapKit/MapKit.h>
#import "IGEOMapMarker.h"
#import "IGEOConfigsManager.h"
#import "IGEOUtils.h"
#import "IGEOPolygon.h"
#import "IGEOListViewController.h"
#import "IGEOCategoryMapListCell.h"
#import "IGEODetailsViewController.h"
#import "IGEONativeMapScreenConfig.h"

/**
 Este view controller apresenta os items obtidos através de pins e poligonos quando aplicável.
 */
@interface IGEOMapViewController ()

@property (nonatomic, strong) UIAlertView *alert;

@property (nonatomic) BOOL dataItemsReceived;
@property (nonatomic) BOOL  error;

//Thread usada para a obtenção dos items
@property (nonatomic, strong) NSThread *threadGetDataItemsMap;

//Este dicionário permite associar a cada um dos pins um item, isto facilita a ação que queremos
//executar ao clicar no balão do pin.
@property (nonatomic, strong) NSMutableDictionary *dictMarkersDataItems;

//Indica se o menu está aberto.
@property (nonatomic) BOOL menuOpen;

//Indica o ID do ponto atualmente selecionado ou -1 se não estiver nenhum ponto selecionado.
@property (nonatomic, strong) NSString *selectedID;

@end



@implementation IGEOMapViewController

//Constantes utilizadas no menu
static const float MENU_SIZE = 255.0f;
static const float MENU_PADDING = 65.0f;
//--

@synthesize mMap = _mMap;
@synthesize bback = _bback;
@synthesize bHome = _bHome;
@synthesize bList = _bList;
@synthesize bMenu = _bMenu;
@synthesize fromExplore = _fromExplore;
@synthesize viewMenu = _viewMenu;
@synthesize listViewMenu = _listViewMenu;
@synthesize tSubtitle = _tSubtitle;
@synthesize viewLoading = _viewLoading;
@synthesize bBackViewLoading = _bBackViewLoading;
@synthesize tLoadingMessage = _tLoadingMessage;

@synthesize dataItemsReceived = _dataItemsReceived;
@synthesize error = _error;
@synthesize threadGetDataItemsMap = _threadGetDataItemsMap;
@synthesize dictMarkersDataItems = _dictMarkersDataItems;
@synthesize menuOpen = _menuOpen;
@synthesize selectedID = _selectedID;

static BOOL reloadData;


//Tamanho máximo permitido para a textview onde colocamos o nome da fonte que estamos a utilizar.
static const int MAX_TAM_SUBTITLE = 132;


#pragma mark - Métodos do ViewController

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
    
    [_bback setImage:[UIImage imageNamed:@"back_click"] forState:UIControlStateHighlighted];
    [_bHome setImage:[UIImage imageNamed:@"home_click"] forState:UIControlStateHighlighted];
    [_bList setImage:[UIImage imageNamed:@"lista_click"] forState:UIControlStateHighlighted];
    [_bMenu setImage:[UIImage imageNamed:@"menu_click"] forState:UIControlStateHighlighted];
    
    
    // Lançar a thread para obtenção dos dados
    _threadGetDataItemsMap = [[NSThread alloc] initWithTarget:self selector:@selector(getDataItemsListMap) object:nil];
    [_threadGetDataItemsMap start];
    
    //Adicionar o swipe recognizer
    UISwipeGestureRecognizer * recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightActionViewMenu:)];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_viewMenu addGestureRecognizer:recognizerRight];
    
    [_mMap setDelegate:self];
    
    [_tSubtitle setText:[IGEODataManager actualSource].sourcename];
    
    //Coloca um padding lateram dentro da label onde temos o titulo da fonte
    CGRect r = _tSubtitle.frame;
    int initualWidth = r.size.width;
    CGSize s;
    r.size.width = ([_tSubtitle sizeThatFits:s].width + 15 < MAX_TAM_SUBTITLE ? [_tSubtitle sizeThatFits:s].width + 15 : MAX_TAM_SUBTITLE);
    r.origin.x -= (r.size.width - initualWidth)/2;
    [_tSubtitle setFrame:r];
    
    //Aplica as configurações do ecrã
    [self applyConfigs];
    
    [_tLoadingMessage setText:[IGEOUtils getStringForKey:@"LOADING_MAP"]];
    
}


-(void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    _mMap.showsUserLocation = YES;
    
    //adicionar o observer para receber o resultado das listas
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFinishLoadDataItemsMap:)
                                                 name:@"FinishLoadDataItems"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveJSONErrorDataItemsMap:)
                                                 name:@"JSONErrorDataItemsMap"
                                               object:nil];
    
    //Existem alguns casos em que pretendemos fazer reload dos dados do mapa, isto acontece quando entramos no mapa
    //vamos á lista, fazemos uma pesquisa, e voltamos ao mapa
    if(reloadData){
        //mostrar o alert
        [_viewLoading setHidden:NO];
        
        //remover os pins
        NSInteger toRemoveCount = _mMap.annotations.count;
        NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
        for (id annotation in _mMap.annotations)
            if (annotation != _mMap.userLocation)
                [toRemove addObject:annotation];
        [_mMap removeAnnotations:toRemove];
        
        //remover os poligonos
        [_mMap removeOverlays:[_mMap overlays]];
        
        [_dictMarkersDataItems removeAllObjects];
        
        _dataItemsReceived = NO;
        
        // Lançar a thread para obtenção dos dados
        _threadGetDataItemsMap = [[NSThread alloc] initWithTarget:self selector:@selector(getDataItemsListMap) object:nil];
        [_threadGetDataItemsMap start];
        
        reloadData = false;
    }
    
}


-(void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [IGEODataManager clearTemporaryDataItems];
    
    //remover os pins
    NSInteger toRemoveCount = _mMap.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in _mMap.annotations)
        if (annotation != _mMap.userLocation)
            [toRemove addObject:annotation];
    [_mMap removeAnnotations:toRemove];
    
    //remover os poligonos
    [_mMap removeOverlays:[_mMap overlays]];
    
    if(!_fromList)
        [IGEODataManager clearKeywords];
    
    [super viewDidUnload];
}


-(void) viewWillDisappear:(BOOL)animated
{
    _mMap.showsUserLocation = NO;
    
    //cancela a thread que obtém os items.
    if(_threadGetDataItemsMap != nil){
        if([_threadGetDataItemsMap isExecuting])
            [_threadGetDataItemsMap cancel];
        
        _threadGetDataItemsMap = nil;
    }
    
    [_viewLoading setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self bBackClicked:nil];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showListFromMap"]){
        IGEOListViewController *vc = (IGEOListViewController *) segue.destinationViewController;
        [vc setFromMap:YES];
        [vc setFromExplore:_fromExplore];
    
    }
    else if([segue.identifier isEqualToString:@"showDetailsFromMap"]){
        IGEODetailsViewController *vc = (IGEODetailsViewController *) segue.destinationViewController;
        [vc setItemID:_selectedID];
    }
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















#pragma mark - clique nos botões

- (IBAction)bBackClicked:(id)sender {
    if(!_fromList)
        [IGEODataManager clearKeywords];
    
    if(_threadGetDataItemsMap != nil){
        if([_threadGetDataItemsMap isExecuting])
            [_threadGetDataItemsMap cancel];
        
        _threadGetDataItemsMap = nil;
    }
    
    [_viewLoading setHidden:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)bHomeClicked:(id)sender {
    [IGEODataManager clearCurrentFilterCategories];
    [IGEODataManager clearKeywords];
    
    if(!_fromList)
        [IGEODataManager clearKeywords];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_mMap removeAnnotations:_mMap.annotations];
    [_mMap removeOverlays:_mMap.overlays];
    
    //quando se volta à home é importante limparas categorias que estamos a usar
    //e dos items carregados atualmente.
    [IGEODataManager clearCurrentFilterCategories];
    [IGEODataManager clearTemporaryDataItems];
    
    if(_threadGetDataItemsMap != nil){
        if([_threadGetDataItemsMap isExecuting])
            [_threadGetDataItemsMap cancel];
        
        _threadGetDataItemsMap = nil;
    }
    
    [_viewLoading setHidden:YES];
    
    [self performSegueWithIdentifier:@"backHomeFromMap" sender:self];
}


- (IBAction)bListClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(_threadGetDataItemsMap != nil){
        if([_threadGetDataItemsMap isExecuting])
            [_threadGetDataItemsMap cancel];
        
        _threadGetDataItemsMap = nil;
    }
    
    [_viewLoading setHidden:YES];
    
    
    if(!_fromList)
        [self performSegueWithIdentifier:@"showListFromMap" sender:self];
    else
        [self.navigationController popViewControllerAnimated:YES];
}





/**
 Este método é utilizado para fechar ou abrir a legenda do mapa consoante ela esteja aberta ou fechada.
 A abertura e fecho da legenda é feita através de uma animação que desliza a view com a tabela das categorias com os pins correspondentes
 para a esquerda ou para a direita respetivamente.
 */
- (IBAction)bMenuClicked:(id)sender {
    CGRect currentViewMenuRect = _viewMenu.frame;
    CGRect currentBMenuRect = _bMenu.frame;
    
    if(_menuOpen){
        
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect screenRect = [[UIScreen mainScreen] bounds];
                         CGFloat screenWidth = screenRect.size.width;
                         [_bMenu setFrame:CGRectMake(currentBMenuRect.origin.x+MENU_SIZE, currentBMenuRect.origin.y,
                                                        currentBMenuRect.size.width, currentBMenuRect.size.height)];
                         [_viewMenu setFrame:CGRectMake(screenWidth, currentViewMenuRect.origin.y,
                                                                currentViewMenuRect.size.width, currentViewMenuRect.size.height)];
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                             _menuOpen = NO;
                             [_bMenu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
                             [_bback setHidden:NO];
                             [_bHome setHidden:NO];
                             [_bList setHidden:NO];
                             [_mMap setUserInteractionEnabled:YES];
                         }
                     }
     ];
    }
    else {
        [_bMenu setImage:[UIImage imageNamed:@"fechar_menu.png"] forState:UIControlStateNormal];
        [_bback setHidden:YES];
        [_bHome setHidden:YES];
        [_bList setHidden:YES];
        [_mMap setUserInteractionEnabled:NO];
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             [_bMenu setFrame:CGRectMake(currentBMenuRect.origin.x-MENU_SIZE, currentBMenuRect.origin.y,
                                                            currentBMenuRect.size.width, currentBMenuRect.size.height)];
                             [_viewMenu setFrame:CGRectMake(MENU_PADDING, currentViewMenuRect.origin.y,
                                                            currentViewMenuRect.size.width, currentViewMenuRect.size.height)];
                         }
                         completion:^(BOOL finished){
                             if(finished) {
                                 _menuOpen = YES;
                             }
                         }
         ];
    }
}





















#pragma mark - notifications

/**
 Este método é chamado quando termina a obtenção dos items do servidor. Caso essa operação tenha sido bem
 sucedida, iremos adicionar no mapa os pins correspondente aos items e os poligonos.
 */
-(void) receiveFinishLoadDataItemsMap:(NSNotification *) n
{
    if(_dataItemsReceived || _error)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_viewLoading setHidden:YES];
        
        if([IGEOJSONServerReader temporaryCategories]==nil){
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"MAP_DONT_EXISTS_ALERT_TITLE"]
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else if([[IGEOJSONServerReader temporaryCategories] count]==0){
            _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"MAP_DONT_EXISTS_ALERT_TITLE"]
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                                      otherButtonTitles: nil];
            [_alert show];
        }
        else {
            NSArray *tmpArray = [IGEOJSONServerReader temporaryDataItems];
            [IGEODataManager clearTemporaryDataItems];
            for(IGEOGenericDataItem *di in tmpArray){
                [[IGEODataManager localHashMapDataItems] setObject:di forKey:di.itemID];
            }
            
            tmpArray = nil;
            
            //adicionar os items no mapa
            [self addDataItemsOnMap];
            
            [IGEODataManager addTemporaryDataItems:[tmpArray mutableCopy]];
            
        }
    });
    
}


-(void) receiveJSONErrorDataItemsMap:(NSNotification *) n
{
    if(_dataItemsReceived || _error)
        return;
    
    _dataItemsReceived = YES;
    
    ////NSLog(@"Erro no JSON!");
    
    [_viewLoading setHidden:YES];
    _alert = [[UIAlertView alloc] initWithTitle:[IGEOUtils getStringForKey:@"MAP_ERROR_ALERT_TITLE"]
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:[IGEOUtils getStringForKey:@"BACK_TEXT"]
                              otherButtonTitles: nil];
    [_alert show];
}






#pragma mark - Pontos e poligonos no mapa

/**
 Este é um dos métodos mais importantes deste ViewController pois é através dele que adicionamos items no mapa.
 */
-(void) addDataItemsOnMap
{
    _dictMarkersDataItems = [[NSMutableDictionary alloc] init];
    int cont = 0;
    
    //percorremos a lista de items
    for(IGEOGenericDataItem *di in [[IGEODataManager localHashMapDataItems] allValues]){
        
        
        if([di locationCoordenates]==nil)
            return;
        
        if([[di locationCoordenates] count]==0)
            return;
        
        
        //se é um ponto
        if([[di locationCoordenates] count]<2){
            
            CLLocation *loc = [[di locationCoordenates] objectAtIndex:0];
            IGEOMapMarker *marker = nil;
            marker = [[IGEOMapMarker alloc] initWithItemID:di.itemID categoryID:di.categoryID name:di.title resume:di.textOrHTML coordenates:loc];
            marker.canShowCallout = YES;
            marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [_mMap addAnnotation:marker];
            
            if(cont==0){
                //vamos colocar um zoom sobre o primeiro item adicionado
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 40000, 40000);
                [_mMap setRegion:[_mMap regionThatFits:region] animated:YES];
            }
            
            
            
            
        }
        
        
        //se é um polígono
        else if(![di multiPolygon]){
            
            //adicionamos o ponto central do poligono
            CLLocation *loc =  [di centerPoint];
            IGEOMapMarker *marker = nil;
            marker = [[IGEOMapMarker alloc] initWithItemID:di.itemID categoryID:di.categoryID name:di.title resume:di.textOrHTML coordenates:loc];
            marker.canShowCallout = YES;
            marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [_mMap addAnnotation:marker];
            
            if(cont==0){
                //vamos colocar um zoom sobre o primeiro item adicionado
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 40000, 40000);
                [_mMap setRegion:[_mMap regionThatFits:region] animated:YES];
            }
            
            if(![[IGEODataManager nonDrawPolygonSources] containsObject:[IGEODataManager actualSource].sourceID]){
                
                //NSLog(@"draw polygon");
                
                CLLocationCoordinate2D coords[[[di locationCoordenates] count]];
                int i = 0;
                for(CLLocation *loc in [di locationCoordenates]){
                    coords[i] = loc.coordinate;
                    
                    i++;
                }
                
                //adicionamos o poligono
                IGEOPolygon *polygon = (IGEOPolygon *) [IGEOPolygon polygonWithCoordinates:coords count:[[di locationCoordenates] count]];
                polygon.categoryID = di.categoryID;
                [_mMap addOverlay: polygon];
                
                polygon = nil;
            }
            
        }
        
        
        //se é um multipolígono
        else if([di multiPolygon]){
            
            //adicionamos o ponto central do poligono
            CLLocation *loc =  [di centerPoint];
            IGEOMapMarker *marker = nil;
            marker = [[IGEOMapMarker alloc] initWithItemID:di.itemID categoryID:di.categoryID name:di.title resume:di.textOrHTML coordenates:loc];
            marker.canShowCallout = YES;
            marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [_mMap addAnnotation:marker];
            
            if(cont==0){
                //zoom
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 40000, 40000);
                [_mMap setRegion:[_mMap regionThatFits:region] animated:YES];
            }
            
            //só vamos desenhar poligonos se a fonte em que estamos permite o desenho de poligonos
            //isto permite evitar erros
            if(![[IGEODataManager nonDrawPolygonSources] containsObject:[IGEODataManager actualSource].sourceID]){
                
                int offset = 0;
                IGEOPolygon *polygon = nil;
                //para cada um dos índices da lista de coordenadas de um ponto no qual mudamos de polígono
                //isto permite que a cada ciclo obtenhamos os items de um dos polígonos 
                for(NSNumber *pos in [di lastPolygonCoordenates]){
                    
                    int lenght = [pos intValue] - offset;
                    CLLocationCoordinate2D coords[lenght];
                    int i;
                    int contCoords = 0;
                    CLLocation *loc = nil;
                    for(i = offset;i<[pos intValue];i++){
                        loc = [[di locationCoordenates] objectAtIndex:i];
                        coords[contCoords] = loc.coordinate;
                        
                        contCoords++;
                    }
                    
                    //coloca um pin no ultimo ponto do poligono
                    //dado que temos vários polígonos, o ultimo ponto de cada polígono será também utilizado para colocar um pin
                    //para que possamos ter acesso à informação do mesmo.
                    marker = [[IGEOMapMarker alloc] initWithItemID:di.itemID categoryID:di.categoryID name:di.title resume:di.textOrHTML coordenates:loc];
                    marker.canShowCallout = YES;
                    marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                    [_mMap addAnnotation:marker];
                    
                    offset = [pos intValue];
                    
                    polygon = (IGEOPolygon *) [IGEOPolygon polygonWithCoordinates:coords count:lenght];
                    polygon.categoryID = di.categoryID;
                    [_mMap addOverlay: polygon];
                    
                    offset = [pos intValue];
                    
                    loc = nil;
                }
                
                polygon = nil;
            }
            
        }
        
        
    }
}












#pragma mark - obtenção de dados

/**
 Obtém os items a carregar no mapa, dependendo do ecrã de onde vimos, do perto de mim ou do explore.
 Temos ainda em consideração de estamos a voltar de uma pesquisa por palavras chave na lista.
 */
-(void) getDataItemsListMap
{
    
    if(!_fromList){
        if(_fromExplore){
            if([IGEODataManager keywords]==nil)
                [IGEODataManager getListForSource:[IGEODataManager actualSource].sourceID AndCategoriesInSearchLocation:[IGEODataManager getActualCategoriesListActualFilterIDS]];
            else
                [IGEODataManager getListForSource:[IGEODataManager actualSource].sourceID AndCategories:[IGEODataManager getActualCategoriesListActualFilterIDS] InSearchLocationFiltered:[IGEODataManager keywords]];
        }
        else {
            if([IGEODataManager keywords]==nil)
                [IGEODataManager getListForSource:[IGEODataManager actualSource].sourceID AndCategories:[IGEODataManager getActualCategoriesListActualFilterIDS] Near:[[IGEOLocationManager sharedLocationManager] actualLocation]];
            else
                [IGEODataManager getListForSource:[IGEODataManager actualSource].sourceID AndCategories:[IGEODataManager getActualCategoriesListActualFilterIDS] Near:[[IGEOLocationManager sharedLocationManager] actualLocation] Filtered:[IGEODataManager keywords]];
        }
    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addDataItemsOnMap];
            [_viewLoading setHidden:YES];
        });
    }
    
}











#pragma mark - métodos do delegate do mapa

- (void)mapView:(MKMapView *)map annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    _selectedID = ((IGEOMapMarker *) view.annotation).itemID;
    [self performSegueWithIdentifier:@"showDetailsFromMap" sender:self];
}


-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    ////NSLog(@"item selected");
}


/**
 Neste método definimos as especificações dos pins a adicionar no mapa.
 */
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    
    @try {
        if ([annotation isKindOfClass:[MKUserLocation class]])
            return nil;
        else {
            
            NSString *categoryID = ((IGEOMapMarker *) annotation).categoryID;
            
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:@"pinView"];
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:[IGEOConfigsManager getPinIconForCategory:categoryID]];
            
            
            //Alterado para permitir imageNamed ou imageWithContentsOfFile
            NSString *urlPin = [IGEOConfigsManager getPinIconForCategory:categoryID];
            if([urlPin hasPrefix:@"/"]){
                annotationView.image = [UIImage imageWithContentsOfFile:urlPin];
            }
            else {
                //NSLog(@"imageNamed");
                annotationView.image = [UIImage imageNamed:urlPin];
            }
            
            
            [annotationView setFrame:CGRectMake(0, 0, 40, 40)];
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton setTitle:annotation.title forState:UIControlStateNormal];
            annotationView.rightCalloutAccessoryView = rightButton;
            annotationView.canShowCallout = YES;
            annotationView.draggable = YES;
            return annotationView;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    
}


-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay{
    if([overlay isKindOfClass:[MKPolygon class]]){
        MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
        view.lineWidth=1;
        
        IGEOPolygon *polygon = (IGEOPolygon *) overlay;
        
        //colocar as cores por categoria
        view.strokeColor=[IGEOUtils colorWithHexString:[IGEOConfigsManager getColorForHTMLCategory:polygon.categoryID] alpha:1.0f];
        view.fillColor=[IGEOUtils colorWithHexString:[IGEOConfigsManager getColorForHTMLCategory:polygon.categoryID] alpha:0.6f];
        //--
        
        return view;
    }
    return nil;
}


























#pragma mark - categories list

#pragma mark - Table view datasource

/**
 A lista aqui construida é utilizadfa para apresentar a legenda do mapa
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[IGEODataManager getActualCategoriesListActualFilterIDS] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"IGEOCategoryMapListCell";
    
    IGEOCategoryMapListCell *cell = (IGEOCategoryMapListCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IGEOCategoryMapListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //obtemos a categoria e colocamos no item da lista o pin e a categoria
    IGEOCategory *c = [[IGEODataManager getFilterCategories] objectAtIndex:indexPath.row];
    //
    cell.name.text= c.categoryName;
    cell.imgPin.image = [UIImage imageNamed:
                       [IGEOConfigsManager getPinIconForCategory:c.categoryID
                        ]
                       ];
    
    
    //Alterado para permitir imageNamed ou imageWithContentsOfFile
    NSString *urlPin = [IGEOConfigsManager getPinIconForCategory:c.categoryID];
    if([urlPin hasPrefix:@"/"]){
        cell.imgPin.image = [UIImage imageWithContentsOfFile:urlPin];
    }
    else {
        cell.imgPin.image = [UIImage imageNamed:urlPin];
    }
    
    
    [cell.name setUserInteractionEnabled:NO];
    [cell.imgPin setUserInteractionEnabled:NO];
    
    
    //limpar cor de fundo para nao ficar opaco
    cell.backgroundColor = [UIColor clearColor];
    [tableView setBackgroundColor:[UIColor clearColor]];
    
    //definir a view de seleção
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
    bgView.backgroundColor = [IGEOUtils colorWithHexString:[[IGEOConfigsManager getAppConfigs] appColor] alpha:0.0f];
    cell.selectedBackgroundView = bgView;
    
    //retirar o separador entre celulas
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    return cell;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}













#pragma mark - métodos do swipe

//neste caso o swipe é utilizado para fechar a legenda do mapa quando ela está aberta.
-(void) myRightActionViewMenu:(UISwipeGestureRecognizer*)recognizer
{
    [self bMenuClicked:nil];
}






/**
 Obtém as configs do ConfigsManager e aplica-as nas views respetivas
 */
-(void) applyConfigs
{
    [_tSubtitle setFont: [UIFont fontWithName:[IGEOUtils getStringForKey:@"ROBOTO_REGULAR"] size:14]];
    [_tSubtitle setBackgroundColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppColor] alpha:1.0f]];
    
    [_tSubtitle setBackgroundColor:[IGEOUtils colorWithHexString:[IGEOConfigsManager getAppColor] alpha:1.0f]];
}


#pragma mark - click no back da loadingView

- (IBAction)bBackLoadingViewClicked:(id)sender {
    [self bBackClicked:nil];
}



@end
