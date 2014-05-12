//
//  IGEOConfigsManager.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOConfigsManager.h"
#import "IGEOAppConfigs.h"
#import "IGEOInitialConfigs.h"
#import "IGEODataManager.h"
#import "IGEOScreenConfig.h"
#import "IGEOHomeScreenConfigs.h"
#import "IGEOListSourcesScreenConfig.h"
#import "IGEOSelectLocationScreenConfigs.h"
#import "IGEOOptionsScreenConfig.h"
#import "IGEONativeMapScreenConfig.h"
#import "IGEOListScreenConfig.h"
#import "IGEODetailsScreenConfigs.h"
#import "IGEOInfoScreenConfig.h"
#import "IGEOAppDelegate.h"
#import "IGEOGlobalConfigsItem.h"
#import "IGEOFileUtils.h"
#import "IGEOUtils.h"

@implementation IGEOConfigsManager

//Domínio do URL utilizado nas consultas ao servidor
static const NSString *INIT_URL = @"http://dadosabertos.bitcliq.com";

//Prefixos das key's a utilizar no dicionário com o número de versão das configs
//por exemplo para a categoria 2 da fonte 1 teremos: cat_1_2
static const NSString *APP_DEFAULTS_KEY = @"app_defaults";
static const NSString *SOURCE_KEY = @"src_";
static const NSString *CATEGORY_KEY = @"cat_";

//Nome do ficheiro onde serão colocadas as configs alteradas após a aplicação ir para background e de onde serão lidas
//quando a mesma volta para foreground (caso o ficheiro já exista).
static const NSString *CONFIGS_FILE_NAME = @"configs_app.dat";

//nomes dos ficheiros
static const NSString *HOME_DEFAULT_BG = @"home_default_bg";
static const NSString *LIST_DEFAULT_BG = @"list_default_bg";
static const NSString *HOME_BG = @"home_bg_src_";
static const NSString *LIST_BG = @"list_bg_src_";
static const NSString *CAT_DEFAULT_IMG = @"cat_default_img";
static const NSString *CAT_SELECTED_DEFAULT_IMG = @"cat_selected_default_img";
static const NSString *CAT_DEFAULT_PIN = @"cat_default_pin";
static const NSString *CAT_IMG = @"cat_img_";
static const NSString *CAT_SELECTED_IMG = @"cat_selected_img_";
static const NSString *CAT_PIN_ = @"cat_pin_";

//Configs --
//Configurações da app
static IGEOAppConfigs *myAppConfigs;

//Configurações dos ecrãs da app
static NSMutableDictionary *screenConfigs;

//Este dicionário é utilizado para associar a cada item (cujas configurações são alteráveis pelo servidor), o número da versão
//das mesmas.
static NSMutableDictionary *configsVersionDictionary;
//--

#pragma mark - configs da app
+(NSString *) getAppName
{
    return myAppConfigs.appName;
}


+(NSString *) getAppPackage{
    return myAppConfigs.appPackageName;
}


+(IGEOAppConfigs *) getAppConfigs
{
    return myAppConfigs;
}


#pragma mark - configs dos ecrãs
+(NSDictionary *) getScreensConfigs
{
    return screenConfigs;
}

/**
 Atribui a um ecrã da app, através da key utilizada para o referenciar, as suas configurações de ecrã.
 Estas key's estão definidas no ficheiro das strings.
 */
+(void) setScreenConfig:(NSString *) screen config:(IGEOScreenConfig *) config
{
    [screenConfigs setObject:config forKey:screen];
}






/**
 Este método é utilizado para aplicar as configurações quando iniciamos a App. Essas configurações podem ser lidas
 de um ficheiro, caso ele já tenha sido criado, sendo que essa escrita das configs no ficheiro acontece logo na primeira vez que colocamos
 a App em background, ou pode ser obtida através dos métodos da classe IGEOInitialConfigs
 */
+(void) applyCurrentConfigs
{
    //se já existe lê as configs do ficheiro
    if([IGEOFileUtils fileExists:[NSString stringWithFormat:@"%@",CONFIGS_FILE_NAME]]){
        NSLog(@"a ler configs");
        IGEOGlobalConfigsItem *confItem = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@", [IGEOFileUtils docsPath], CONFIGS_FILE_NAME]];
        myAppConfigs = confItem.appConfigs;
        screenConfigs = confItem.screenConfigs;
        configsVersionDictionary = confItem.configsVersionDictionary;
        NSLog(@"terminou a leitura de configs");
        
        confItem = nil;
    }
    
    //se ainda não existe lê as configs da classe IGEOInitialConfigs
    else {
        myAppConfigs = [IGEOInitialConfigs getAppConfigs];
        
        IGEOHomeScreenConfigs *homeScreenConfigs = [IGEOInitialConfigs getHomeScreenConfigs];
        IGEOListSourcesScreenConfig *listSourcesScreenConfigs = [IGEOInitialConfigs getListSourcesScreenConfigs];
        IGEOSelectLocationScreenConfigs *selectLocationScreenConfigs = [IGEOInitialConfigs getSelectLocationScreenConfigs];
        IGEOInfoScreenConfig *infoScreenConfigs = [IGEOInitialConfigs getInfoSCreenConfigs];
        IGEOOptionsScreenConfig *optionsScreenConfigs = [IGEOInitialConfigs getOptionsScreenConfigs];
        IGEONativeMapScreenConfig *nativeMapScreenConfigs = [IGEOInitialConfigs getNativeMapScreenConfigs];
        IGEOListScreenConfig *listScreenConfigs = [IGEOInitialConfigs getListScreenConfigs];
        IGEODetailsScreenConfigs *detailsScreenConfigs = [IGEOInitialConfigs getDetailsScreenConfigs];
        
        screenConfigs = [[NSMutableDictionary alloc] init];
        [screenConfigs setObject:homeScreenConfigs forKey:[IGEOUtils getStringForKey:@"HOME_KEY"]];
        [screenConfigs setObject:listSourcesScreenConfigs forKey:[IGEOUtils getStringForKey:@"SOURCES_LIST_KEY"]];
        [screenConfigs setObject:selectLocationScreenConfigs forKey:[IGEOUtils getStringForKey:@"FILTER_EXPLORE_KEY"]];
        [screenConfigs setObject:infoScreenConfigs forKey:[IGEOUtils getStringForKey:@"INFO_KEY"]];
        [screenConfigs setObject:optionsScreenConfigs forKey:[IGEOUtils getStringForKey:@"OPTIONS_KEY"]];
        [screenConfigs setObject:nativeMapScreenConfigs forKey:[IGEOUtils getStringForKey:@"MAP_KEY"]];
        [screenConfigs setObject:listScreenConfigs forKey:[IGEOUtils getStringForKey:@"LIST_KEY"]];
        [screenConfigs setObject:detailsScreenConfigs forKey:[IGEOUtils getStringForKey:@"DETAILS_KEY"]];
    }
}






#pragma mark - Métodos para obtenção de configs específicas de cada ecrã

/**
 Obtém o nome da imagem a utilizar como fundo na home para uma fonte.
 */
+(NSString *) getBackgroundImageForSource:(NSString *) srcID
{
    //return [IGEOMockupConfigs getBackgroundImageForSource:srcID];
    IGEOHomeScreenConfigs *homeConfigs = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"HOME_KEY"]];
    if([homeConfigs.backgroundConf objectForKey:srcID] != nil){
        return [homeConfigs.backgroundConf objectForKey:srcID];
    }
    else {
        return [homeConfigs.backgroundConf objectForKey:@"-1"];
    }
}


/**
 Obtém o nome da imagem a utilizar como fundo na lista para uma fonte.
 */
+(NSString *) getBackgroundRightImageForSource:(NSString *) srcID
{
    IGEOListScreenConfig *listConfigs = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"LIST_KEY"]];
    if([listConfigs.bgForSource objectForKey:srcID] != nil){
        return [listConfigs.bgForSource objectForKey:srcID];
    }
    else {
        return [listConfigs.bgForSource objectForKey:@"-1"];
    }
}


/**
 Obtém o nome da imagem a utilizar num ícone no seu estado normal, utilizado por uma categoria de uma fonte.
 */
+(NSString *) getIconForSource:(NSString *) sourceID AndCategory:(NSString *) categoryID
{
    IGEOOptionsScreenConfig *optionsConfigs = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"OPTIONS_KEY"]];
    if([optionsConfigs.buttonsOptionConf objectForKey:[NSString stringWithFormat:@"%@_%@", sourceID, categoryID]] != nil){
        IGEOButtonElement *btnTmp = [optionsConfigs.buttonsOptionConf objectForKey:[NSString stringWithFormat:@"%@_%@", sourceID, categoryID]];
        return btnTmp.imageNormalConfigs;
    }
    else {
        IGEOButtonElement *btnTmp = [optionsConfigs.buttonsOptionConf objectForKey:@"-1"];
        return btnTmp.imageNormalConfigs;
    }
}


/**
 Obtém o nome da imagem a utilizar num ícone no seu estado selecionado, utilizado por uma categoria de uma fonte.
 */
+(NSString *) getIconForSource:(NSString *) sourceID AndCategorySelected:(NSString *) categoryID
{
    IGEOOptionsScreenConfig *optionsConfigs = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"OPTIONS_KEY"]];
    if([optionsConfigs.buttonsOptionConf objectForKey:[NSString stringWithFormat:@"%@_%@", sourceID, categoryID]] != nil){
        IGEOButtonElement *btnTmp = [optionsConfigs.buttonsOptionConf objectForKey:[NSString stringWithFormat:@"%@_%@", sourceID, categoryID]];
        return btnTmp.imageClickConfigs;
    }
    else {
        IGEOButtonElement *btnTmp = [optionsConfigs.buttonsOptionConf objectForKey:@"-1"];
        return btnTmp.imageClickConfigs;
    }
}


/**
 Obtém o nome da imagem a utilizar no pin do mapa, utilizado por uma categoria de uma fonte.
 */
+(NSString *) getPinIconForCategory:(NSString *) categoryID
{
    IGEONativeMapScreenConfig *map = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"MAP_KEY"]];
    if([map.pinLegendCategory objectForKey:categoryID] != nil){
        return [map.pinLegendCategory objectForKey:categoryID];
    }
    else {
        NSString *key = [categoryID substringFromIndex:[categoryID length]-1];
        if([map.pinLegendCategory objectForKey:key] != nil) {
            return [map.pinLegendCategory objectForKey:key];
        }
        else {
            return [map.pinLegendCategory objectForKey:@"-1"];
        }
    }
}


/**
 Obtém a cor em hexadecimal a ser utilizada por uma categoria de uma fonte.
 */
+(NSString *) getColorForHTMLCategory:(NSString *) categoryID
{
    IGEONativeMapScreenConfig *map = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"MAP_KEY"]];
    if([map.colorHTMLCategory objectForKey:categoryID] != nil){
        return [map.colorHTMLCategory objectForKey:categoryID];
    }
    else {
        NSString *key = [categoryID substringFromIndex:[categoryID length]-1];
        if([map.colorHTMLCategory objectForKey:key] != nil) {
            return [map.colorHTMLCategory objectForKey:key];
        }
        else {
            return [map.colorHTMLCategory objectForKey:@"-1"];
        }
    }
}









/**
 Obtém o nome da imagem de topo a ser utilizada no ecrã da home e em outros ecrãs.
 */
+(NSString *) getTopImage
{
    IGEOHomeScreenConfigs *homeConfigs = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"HOME_KEY"]];
    return homeConfigs.urlTopImage;
}


+(NSString *) getAppTitle
{
    return [[IGEOConfigsManager getAppConfigs].appName uppercaseString];
}


/**
 Obtém num array o nome das 3 imagens a serem utilizadas no estado normal dos botões da home.
 */
+(NSMutableArray *) getHomeIcons
{
    IGEOHomeScreenConfigs *homeConfigs = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"HOME_KEY"]];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(IGEOButtonElement *b in homeConfigs.btns){
        [result addObject:b.imageNormalConfigs];
    }
    
    return result;
}


/**
 Obtém num array o nome das 3 imagens a serem utilizadas no estado selecionado dos botões da home.
 */
+(NSMutableArray *) getHomeIconsClicked
{
    IGEOHomeScreenConfigs *homeConfigs = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"HOME_KEY"]];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(IGEOButtonElement *b in homeConfigs.btns){
        [result addObject:b.imageClickConfigs];
    }
    
    return result;
}


/**
 Obtém a cor usada na seleção dos itens das listas.
 */
+(NSString *) getListsSelectionColor
{
    IGEOListScreenConfig *listConf = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"LIST_KEY"]];
    
    return listConf.colorSelection;
}


/**
 Obtém a cor a ser utilizada em diversos sitios na app.
 Esta é a cor "base" da App.
 */
+(NSString *) getAppColor
{
    return [IGEOConfigsManager getAppConfigs].appColor;
}


+(NSString *) getSubtitleBackground
{
    IGEOHomeScreenConfigs *homeConfigs = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"HOME_KEY"]];
    return homeConfigs.subTitleBg;
}


/**
 Obtém o nome da imagem utilizada por defeito nos detalhes dos items.
 */
+(NSString *) getDefaultImage
{
    IGEODetailsScreenConfigs *detailsConfigs = [screenConfigs objectForKey:[IGEOUtils getStringForKey:@"DETAILS_KEY"]];
    return detailsConfigs.defaultImageURL;
}










#pragma mark - métodos para alteração de cores e imagens das configs

/**
 Altera a cor do titulo da lista para uma categoria de uma fonte.
 */
+(void) changeTitleListColorForSource:(NSString *) srcID AndCategory:(NSString *) catID color:(NSString *) color
{
    //Vamos obter as configs atuais
    IGEONativeMapScreenConfig *mapConfigs = [[IGEOConfigsManager getScreensConfigs] objectForKey:[IGEOUtils getStringForKey:@"MAP_KEY"]];
    
    //retirar o cardinal
    if(color!=nil)
        color = [color substringFromIndex:1];
    
    //alteramos as configs
    [mapConfigs.colorHTMLCategory setObject:color forKey:catID];
    //readicionamos as configs do ecrã na hashmap
    [IGEOConfigsManager setScreenConfig:[IGEOUtils getStringForKey:@"MAP_KEY"] config:mapConfigs];
}


/**
 Altera a cor da linha do polígono para uma categoria de uma fonte.
 */
+(void) changePolygonLineColorForSource:(NSString *) srcID AndCategory:(NSString *) catID color:(NSString *) color
{
    IGEONativeMapScreenConfig *mapConfigs = [[IGEOConfigsManager getScreensConfigs] objectForKey:[IGEOUtils getStringForKey:@"MAP_KEY"]];
    
    //retirar o cardinal
    if(color!=nil)
        color = [color substringFromIndex:1];
    
    [mapConfigs.polygonColorCategory setObject:color forKey:catID];
    [IGEOConfigsManager setScreenConfig:[IGEOUtils getStringForKey:@"MAP_KEY"] config:mapConfigs];
}


/**
 Altera a cor de fundo do polígono para uma categoria de uma fonte.
 */
+(void) changePolygonBackgroundColorForSource:(NSString *) srcID AndCategory:(NSString *) catID color:(NSString *) color
{
    IGEONativeMapScreenConfig *mapConfigs = [[IGEOConfigsManager getScreensConfigs] objectForKey:[IGEOUtils getStringForKey:@"MAP_KEY"]];
    
    //retirar o cardinal
    if(color!=nil)
        color = [color substringFromIndex:1];
    
    [mapConfigs.polygonBackgroundColorCategory setObject:color forKey:catID];
    [IGEOConfigsManager setScreenConfig:[IGEOUtils getStringForKey:@"MAP_KEY"] config:mapConfigs];
}


/**
 Altera o pin a ser utilizado na legenda do mapa para uma categoria de uma fonte.
 */
+(void) changePinMapImageForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url
{
    NSRange rangeBar = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *extension = [url substringFromIndex:rangeBar.location+1];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@_%@.%@", CAT_PIN_, srcID, catID, extension];
    
    [((IGEOAppDelegate *) ([UIApplication sharedApplication].delegate)).downloadConfigsThread
     addItemToDownload:
     [[IGEOConfigDownloadItem alloc] initWithURL:[NSString stringWithFormat:@"%@%@", INIT_URL, url] destinationFolder:fileName source:srcID category:catID type:CatPinImage]
     ];
    
    extension = nil;
    fileName = nil;
}


/**
 Altera a imagem do botão no modo normal, para uma categoria de uma fonte.
 */
+(void) changeCategoryIconNormalForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url
{
    NSRange rangeBar = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *extension = [url substringFromIndex:rangeBar.location+1];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@_%@.%@", CAT_IMG, srcID, catID, extension];
    
    [((IGEOAppDelegate *) ([UIApplication sharedApplication].delegate)).downloadConfigsThread
     addItemToDownload:
     [[IGEOConfigDownloadItem alloc] initWithURL:[NSString stringWithFormat:@"%@%@", INIT_URL, url] destinationFolder:fileName source:srcID category:catID type:CatIconNormal]
     ];
    
    fileName = nil;
}



+(void) changeCategoryIconNormalForSource:(NSString *) srcID defaultUrl:(NSString *) url
{
    NSRange rangeBar = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *extension = [url substringFromIndex:rangeBar.location+1];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@", CAT_DEFAULT_IMG, srcID, extension];
    
    [((IGEOAppDelegate *) ([UIApplication sharedApplication].delegate)).downloadConfigsThread
     addItemToDownload:
     [[IGEOConfigDownloadItem alloc] initWithURL:[NSString stringWithFormat:@"%@%@", INIT_URL, url] destinationFolder:fileName source:srcID category:@"-1" type:CatIconNormal]
     ];
    
    extension = nil;
    fileName = nil;
}


/**
 Altera a imagem do botão (modo selecionado),  para uma categoria de uma fonte.
 */
+(void) changeCategoryIconSelectedForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url
{
    NSRange rangeBar = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *extension = [url substringFromIndex:rangeBar.location+1];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@_%@.%@", CAT_SELECTED_IMG, srcID, catID, extension];
    
    [((IGEOAppDelegate *) ([UIApplication sharedApplication].delegate)).downloadConfigsThread
     addItemToDownload:
     [[IGEOConfigDownloadItem alloc] initWithURL:[NSString stringWithFormat:@"%@%@", INIT_URL, url] destinationFolder:fileName source:srcID category:catID type:CatIconSelected]
     ];
    
    extension = nil;
    fileName = nil;
}



+(void) changeCategoryIconSelectedForSource:(NSString *) srcID defaultUrl:(NSString *) url
{
    NSRange rangeBar = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *extension = [url substringFromIndex:rangeBar.location+1];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@", CAT_SELECTED_DEFAULT_IMG, srcID, extension];
    
    [((IGEOAppDelegate *) ([UIApplication sharedApplication].delegate)).downloadConfigsThread
     addItemToDownload:
     [[IGEOConfigDownloadItem alloc] initWithURL:[NSString stringWithFormat:@"%@%@", INIT_URL, url] destinationFolder:fileName source:srcID category:@"-1" type:CatIconSelected]
     ];
    
    extension = nil;
    fileName = nil;
}


/**
 Altera a imagem de fundo do ecrã da home para uma fonte.
 */
+(void) changeBackgroundImageHomeForSource:(NSString *) srcID url:(NSString *) url
{
    NSRange rangeBar = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *extension = [url substringFromIndex:rangeBar.location+1];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@", HOME_BG, srcID, extension];
    
    [((IGEOAppDelegate *) ([UIApplication sharedApplication].delegate)).downloadConfigsThread
     addItemToDownload:
     [[IGEOConfigDownloadItem alloc] initWithURL:[NSString stringWithFormat:@"%@%@", INIT_URL, url] destinationFolder:fileName source:srcID category:@"-1" type:HomeBgImage]
     ];
    
    extension = nil;
    fileName = nil;
}


/**
 Altera a imagem por defeito, do fundo do ecrã da home.
 */
+(void) changeBackgroundImageHomeDefaultUrl:(NSString *) url
{
    NSRange rangeBar = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *extension = [url substringFromIndex:rangeBar.location+1];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", HOME_DEFAULT_BG, extension];
    
    [((IGEOAppDelegate *) ([UIApplication sharedApplication].delegate)).downloadConfigsThread
     addItemToDownload:
     [[IGEOConfigDownloadItem alloc] initWithURL:[NSString stringWithFormat:@"%@%@", INIT_URL, url] destinationFolder:fileName source:@"-1" category:@"-1" type:HomeBgImage]
     ];
    
    extension = nil;
    fileName = nil;
}


/**
 Altera a imagem de fundo do ecrã da lista de itens para uma fonte.
 */
+(void) changeBackgroundImageListForSource:(NSString *) srcID url:(NSString *) url
{
    NSRange rangeBar = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *extension = [url substringFromIndex:rangeBar.location+1];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@", LIST_BG, srcID, extension];
    
    [((IGEOAppDelegate *) ([UIApplication sharedApplication].delegate)).downloadConfigsThread
     addItemToDownload:
     [[IGEOConfigDownloadItem alloc] initWithURL:[NSString stringWithFormat:@"%@%@", INIT_URL, url] destinationFolder:fileName source:srcID category:@"-1" type:ListBGImage]
     ];
    
    extension = nil;
    fileName = nil;
}


/**
 Altera a imagem por defeito, do fundo do ecrã da lista de itens.
 */
+(void) changeBackgroundImageListDefaultUrl:(NSString *) url
{
    NSRange rangeBar = [url rangeOfString:@"." options:NSBackwardsSearch];
    NSString *extension = [url substringFromIndex:rangeBar.location+1];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", LIST_DEFAULT_BG, extension];
    
    [((IGEOAppDelegate *) ([UIApplication sharedApplication].delegate)).downloadConfigsThread
     addItemToDownload:
     [[IGEOConfigDownloadItem alloc] initWithURL:[NSString stringWithFormat:@"%@%@", INIT_URL, url] destinationFolder:fileName source:@"-1" category:@"-1" type:ListBGImage]
     ];
    
    extension = nil;
    fileName = nil;
}










#pragma mark - métodos síncronos para alteração das imagens das configs
//estes métodos são chamados quando terminamos a obtenção das configs

/**
 Método para alteração de forma síncrona da imagem de fundo na home para uma fonte.
 */
+(void) setHomeBgImageForSource:(NSString *) srcID url:(NSString *) url
{
    IGEOHomeScreenConfigs *homeConfigs = [[IGEOConfigsManager getScreensConfigs] objectForKey:[IGEOUtils getStringForKey:@"HOME_KEY"]];
    [homeConfigs.backgroundConf setObject:url forKey:srcID];
    [IGEOConfigsManager setScreenConfig:[IGEOUtils getStringForKey:@"HOME_KEY"] config:homeConfigs];
}


/**
 Método para alteração de forma síncrona da imagem de fundo na lista para uma fonte.
 */
+(void) setListBgImageForSource:(NSString *) srcID url:(NSString *) url
{
    IGEOListScreenConfig *listConfigs = [[IGEOConfigsManager getScreensConfigs] objectForKey:[IGEOUtils getStringForKey:@"LIST_KEY"]];
    [listConfigs.bgForSource setObject:url forKey:srcID];
    [IGEOConfigsManager setScreenConfig:[IGEOUtils getStringForKey:@"LIST_KEY"] config:listConfigs];
}


+(void) setCatIconNormalForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url
{
    //NSLog(@"setting icon normal for category: %@", url);
    IGEOOptionsScreenConfig *optionsConfigs = [[IGEOConfigsManager getScreensConfigs] objectForKey:[IGEOUtils getStringForKey:@"OPTIONS_KEY"]];
    IGEOButtonElement *btnCatNormal = nil;
    if([catID isEqualToString:@"-1"]){
        btnCatNormal = [optionsConfigs.buttonsOptionConf objectForKey:@"-1"];
        btnCatNormal.imageNormalConfigs = url;
        [optionsConfigs.buttonsOptionConf setObject:btnCatNormal forKey:@"-1"];
    }
    else {
        if([optionsConfigs.buttonsOptionConf objectForKey:[NSString stringWithFormat:@"%@_%@", srcID, catID]]==nil){
            btnCatNormal = [[IGEOButtonElement alloc] init];
            btnCatNormal.imageNormalConfigs = url;
            [optionsConfigs.buttonsOptionConf setObject:btnCatNormal forKey:[NSString stringWithFormat:@"%@_%@", srcID, catID]];
        }
        else {
            btnCatNormal = [optionsConfigs.buttonsOptionConf objectForKey:[NSString stringWithFormat:@"%@_%@", srcID, catID]];
            btnCatNormal.imageNormalConfigs = url;
            [optionsConfigs.buttonsOptionConf setObject:btnCatNormal forKey:[NSString stringWithFormat:@"%@_%@", srcID, catID]];
        }
    }
    
    [IGEOConfigsManager setScreenConfig:[IGEOUtils getStringForKey:@"OPTIONS_KEY"] config:optionsConfigs];
}


/**
 Método para alteração de forma síncrona do ícone do ecrã de seleção de categorias, para uma categoria de uma fonte.
 */
+(void) setCatIconSelectedForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url
{
    IGEOOptionsScreenConfig *optionsConfigs = [[IGEOConfigsManager getScreensConfigs] objectForKey:[IGEOUtils getStringForKey:@"OPTIONS_KEY"]];
    IGEOButtonElement *btnCatNormal = nil;
    if([catID isEqualToString:@"-1"]){
        btnCatNormal = [optionsConfigs.buttonsOptionConf objectForKey:@"-1"];
        btnCatNormal.imageClickConfigs = url;
        [optionsConfigs.buttonsOptionConf setObject:btnCatNormal forKey:@"-1"];
    }
    else {
        if([optionsConfigs.buttonsOptionConf objectForKey:[NSString stringWithFormat:@"%@_%@", srcID, catID]]==nil){
            btnCatNormal = [[IGEOButtonElement alloc] init];
            btnCatNormal.imageClickConfigs = url;
            [optionsConfigs.buttonsOptionConf setObject:btnCatNormal forKey:[NSString stringWithFormat:@"%@_%@", srcID, catID]];
        }
        else {
            btnCatNormal = [optionsConfigs.buttonsOptionConf objectForKey:[NSString stringWithFormat:@"%@_%@", srcID, catID]];
            btnCatNormal.imageClickConfigs = url;
            [optionsConfigs.buttonsOptionConf setObject:btnCatNormal forKey:[NSString stringWithFormat:@"%@_%@", srcID, catID]];
        }
    }
    
    [IGEOConfigsManager setScreenConfig:[IGEOUtils getStringForKey:@"OPTIONS_KEY"] config:optionsConfigs];
}


/**
 Método para alteração de forma síncrona da imagem do pin da legenda do mapa, para uma categoria de uma fonte.
 */
+(void) setCatPinImageForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url
{
    IGEONativeMapScreenConfig *mapConfigs = [[IGEOConfigsManager getScreensConfigs] objectForKey:[IGEOUtils getStringForKey:@"MAP_KEY"]];
    [mapConfigs.pinLegendCategory setObject:url forKey:catID];
    [IGEOConfigsManager setScreenConfig:[IGEOUtils getStringForKey:@"MAP_KEY"] config:mapConfigs];
}







#pragma mark - métodos para gestão da versão das configs

+(NSMutableDictionary *) configsVersionDictionary
{
    return configsVersionDictionary;
}


+(int) getVersionNumberForAppDefaults
{
    if(configsVersionDictionary == nil)
        configsVersionDictionary = [[NSMutableDictionary alloc] init];
    
    if([configsVersionDictionary objectForKey:APP_DEFAULTS_KEY] != nil){
        return [[configsVersionDictionary objectForKey:APP_DEFAULTS_KEY] intValue];
    }
    else {
        [configsVersionDictionary setObject:[NSNumber numberWithInt:-1] forKey:APP_DEFAULTS_KEY];
        return [[configsVersionDictionary objectForKey:APP_DEFAULTS_KEY] intValue];
    }
}


+(void) setVersionNumberForAppDefaults:(int) version
{
    [configsVersionDictionary setObject:[NSNumber numberWithInt:version] forKey:APP_DEFAULTS_KEY];
}


+(int) getVersionNumberForSource:(NSString *) srcID
{
    if(configsVersionDictionary == nil)
        configsVersionDictionary = [[NSMutableDictionary alloc] init];
    
    if([configsVersionDictionary objectForKey:[NSString stringWithFormat:@"%@%@", SOURCE_KEY, srcID]] != nil){
        return [[configsVersionDictionary objectForKey:[NSString stringWithFormat:@"%@%@", SOURCE_KEY, srcID]] intValue];
    }
    else {
        [configsVersionDictionary setObject:[NSNumber numberWithInt:-1] forKey:[NSString stringWithFormat:@"%@%@", SOURCE_KEY, srcID]];
        return [[configsVersionDictionary objectForKey:[NSString stringWithFormat:@"%@%@", SOURCE_KEY, srcID]] intValue];
    }
}


+(void) setVersionNumber:(int) version ForSource:(NSString *) srcID
{
    [configsVersionDictionary setObject:[NSNumber numberWithInt:version] forKey:[NSString stringWithFormat:@"%@%@", SOURCE_KEY, srcID]];
}


+(int) getVersionNumberForSource:(NSString *) srcID AndCategory:(NSString *) catID
{
    if(configsVersionDictionary == nil)
        configsVersionDictionary = [[NSMutableDictionary alloc] init];
    
    if([configsVersionDictionary objectForKey:[NSString stringWithFormat:@"%@%@_%@", CATEGORY_KEY, catID, srcID]] != nil){
        return [[configsVersionDictionary objectForKey:[NSString stringWithFormat:@"%@%@_%@", CATEGORY_KEY, catID, srcID]] intValue];
    }
    else {
        [configsVersionDictionary setObject:[NSNumber numberWithInt:-1] forKey:[NSString stringWithFormat:@"%@%@_%@", CATEGORY_KEY, catID, srcID]];
        return [[configsVersionDictionary objectForKey:[NSString stringWithFormat:@"%@%@_%@", CATEGORY_KEY, catID, srcID]] intValue];
    }
}


+(void) setVersionNumber:(int) version ForSource:(NSString *) srcID AndCategory:(NSString *) catID
{
    [configsVersionDictionary setObject:[NSNumber numberWithInt:version] forKey:[NSString stringWithFormat:@"%@%@_%@", CATEGORY_KEY, catID, srcID]];
}





#pragma mark - leitura e escrita das configs iniciais

/**
 Este método é utilizado para leitura no servidor das configs das imagens por defeito (imagem da home e imagem da lista).
 */
+(void) readDefaultConfigs
{
    [IGEOJSONServerReader readJSONAppDefaultsFromServer:[IGEOConfigsManager getAppConfigs].URLRequestAppDefaults];
}


/**
 Este método é usado para escrever no ficheiro as configurações.
 */
+(void) writeDefaultConfigs
{
     NSLog(@"a guardar configs");
    //Criamos uma variável com as configurações da aplicação, as configurações dos ecrãs e o dicionário com o número das versões
    IGEOGlobalConfigsItem *confItem = [[IGEOGlobalConfigsItem alloc] initWithAppConfigs:myAppConfigs SCreenConfigs:screenConfigs configsVersionDictionary:configsVersionDictionary];
    //Escreve no ficheiro o objeto criado.
    [NSKeyedArchiver archiveRootObject:confItem toFile:[NSString stringWithFormat:@"%@/%@", [IGEOFileUtils docsPath], CONFIGS_FILE_NAME]];
     NSLog(@"configs guardadas");
}

@end
