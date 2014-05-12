//
//  IGEOMockupConfigs.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOInitialConfigs.h"
#import "IGEOConfigsManager.h"
#import "IGEOUtils.h"

@implementation IGEOInitialConfigs

static const NSString *PATRIMONIO = @"Património";
static const NSString *NATUREZA = @"Natureza";
static const NSString *ORDENAMENTO = @"Ordenamento";

/**
 Nome da App que estamos a instanciar. Esta variável deve ser alterada sempre que vamos instanciar uma App diferente.
 */
//static const NSString *APP_NAME = @"Património";
//static const NSString *APP_NAME = @"Natureza";
static const NSString *APP_NAME = @"Ordenamento";


+(IGEOAppConfigs *) getAppConfigs
{
    if(APP_NAME==PATRIMONIO){
        IGEOAppConfigs *result = [[IGEOAppConfigs alloc] initWithAppName:[IGEOUtils getStringForKey:@"PAT_APP_NAME"] PackageName:[IGEOUtils getStringForKey:@"PAT_PACKAGE_NAME"] URLUpdate:@""];
        result.proximityRadius = 10000;
        result.URLRequests = [NSString stringWithFormat:@"%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_REQUEST"], [IGEOUtils getStringForKey:@"PAT"]];
        result.URLRequestsSources = [NSString stringWithFormat:@"%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_SOURCES"], [IGEOUtils getStringForKey:@"PAT"]];
        result.URLRequestsCategories = [NSString stringWithFormat:@"%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_CATEGORIES"], [IGEOUtils getStringForKey:@"PAT"]];
        result.URLRequestAppDefaults = [NSString stringWithFormat:@"%@%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_DEFAULTS"], [IGEOUtils getStringForKey:@"PAT"], @"&imgtype=ios"];
        result.appColor = @"b37202";
        
        return result;
    }
    else if(APP_NAME==NATUREZA){
        IGEOAppConfigs *result = [[IGEOAppConfigs alloc] initWithAppName:[IGEOUtils getStringForKey:@"NAT_APP_NAME"] PackageName:[IGEOUtils getStringForKey:@"NAT_PACKAGE_NAME"]  URLUpdate:@""];
        result.proximityRadius = 10000;
        result.URLRequests = [NSString stringWithFormat:@"%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_REQUEST"], [IGEOUtils getStringForKey:@"NAT"]];
        result.URLRequestsSources = [NSString stringWithFormat:@"%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_SOURCES"], [IGEOUtils getStringForKey:@"NAT"]];
        result.URLRequestsCategories = [NSString stringWithFormat:@"%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_CATEGORIES"], [IGEOUtils getStringForKey:@"NAT"]];
        result.URLRequestAppDefaults = [NSString stringWithFormat:@"%@%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_DEFAULTS"], [IGEOUtils getStringForKey:@"NAT"], @"&imgtype=ios"];
        result.appColor = @"1e9d52";
        
        return result;
    }
    else if(APP_NAME==ORDENAMENTO){
        IGEOAppConfigs *result = [[IGEOAppConfigs alloc] initWithAppName:[IGEOUtils getStringForKey:@"ORD_APP_NAME"] PackageName:[IGEOUtils getStringForKey:@"ORD_PACKAGE_NAME"]  URLUpdate:@""];
        result.proximityRadius = 10000;
        result.URLRequests = [NSString stringWithFormat:@"%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_REQUEST"], [IGEOUtils getStringForKey:@"ORD"]];
        result.URLRequestsSources = [NSString stringWithFormat:@"%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_SOURCES"], [IGEOUtils getStringForKey:@"ORD"]];
        result.URLRequestsCategories = [NSString stringWithFormat:@"%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_CATEGORIES"], [IGEOUtils getStringForKey:@"ORD"]];
        result.URLRequestAppDefaults = [NSString stringWithFormat:@"%@%@%@%@", [IGEOUtils getStringForKey:@"URL_DOMAIN"], [IGEOUtils getStringForKey:@"URL_DEFAULTS"], [IGEOUtils getStringForKey:@"ORD"], @"&imgtype=ios"];
        result.appColor = @"0385fe";
        
        return result;
    }
    
    return nil;
}






#pragma mark - métodos para obtenção das screenconfigs

+(IGEOHomeScreenConfigs *) getHomeScreenConfigs
{
    IGEOHomeScreenConfigs *result = [[IGEOHomeScreenConfigs alloc] init];
    
    if(APP_NAME==PATRIMONIO){
        result.btns = [[NSMutableArray alloc] init];
        
        IGEOButtonElement *btnSourcesList = [[IGEOButtonElement alloc] init];
        [btnSourcesList setName:@"bSourcesList"];
        [btnSourcesList setImageNormalConfigs:@"pat_portugal.png"];
        [btnSourcesList setImageClickConfigs:@"pat_portugal_click.png"];
        
        IGEOButtonElement *btnNearMe = [[IGEOButtonElement alloc] init];
        [btnNearMe setName:@"bNearMe"];
        [btnNearMe setImageNormalConfigs:@"pat_perto_de_mim.png"];
        [btnNearMe setImageClickConfigs:@"pat_perto_de_mim_click.png"];
        
        IGEOButtonElement *btnExplore = [[IGEOButtonElement alloc] init];
        [btnExplore setName:@"bExplore"];
        [btnExplore setImageNormalConfigs:@"pat_explore.png"];
        [btnExplore setImageClickConfigs:@"pat_explore_click.png"];
        
        [result.btns addObject:btnSourcesList];
        [result.btns addObject:btnNearMe];
        [result.btns addObject:btnExplore];
        
        result.backgroundConf = [[NSMutableDictionary alloc] init];
        [result.backgroundConf setObject:@"pat_bg_pelourinho.jpg" forKey:@"1"];
        [result.backgroundConf setObject:@"pat_bg_farois.jpg" forKey:@"2"];
        [result.backgroundConf setObject:@"pat_bg_home.jpg" forKey:@"-1"];
        result.subTitleBg = [IGEOConfigsManager getAppColor];
        result.urlTopImage = @"pat_header_patrimonio.png";
    }
    if(APP_NAME==NATUREZA){
        result.btns = [[NSMutableArray alloc] init];
        
        IGEOButtonElement *btnSourcesList = [[IGEOButtonElement alloc] init];
        [btnSourcesList setName:@"bSourcesList"];
        [btnSourcesList setImageNormalConfigs:@"nat_portugal.png"];
        [btnSourcesList setImageClickConfigs:@"nat_portugal_click.png"];
        
        IGEOButtonElement *btnNearMe = [[IGEOButtonElement alloc] init];
        [btnNearMe setName:@"bNearMe"];
        [btnNearMe setImageNormalConfigs:@"nat_perto_de_mim.png"];
        [btnNearMe setImageClickConfigs:@"nat_perto_de_mim_click.png"];
        
        IGEOButtonElement *btnExplore = [[IGEOButtonElement alloc] init];
        [btnExplore setName:@"bExplore"];
        [btnExplore setImageNormalConfigs:@"nat_explore.png"];
        [btnExplore setImageClickConfigs:@"nat_explore_click.png"];
        
        [result.btns addObject:btnSourcesList];
        [result.btns addObject:btnNearMe];
        [result.btns addObject:btnExplore];
        
        result.backgroundConf = [[NSMutableDictionary alloc] init];
        [result.backgroundConf setObject:@"nat_bg_flora.jpg" forKey:@"4"];
        [result.backgroundConf setObject:@"nat_bg_home.jpg" forKey:@"-1"];
        result.subTitleBg = [IGEOConfigsManager getAppColor];
        result.urlTopImage = @"nat_header_natureza.png";
    }
    if(APP_NAME==ORDENAMENTO){
        result.btns = [[NSMutableArray alloc] init];
        
        IGEOButtonElement *btnSourcesList = [[IGEOButtonElement alloc] init];
        [btnSourcesList setName:@"bSourcesList"];
        [btnSourcesList setImageNormalConfigs:@"ord_portugal.png"];
        [btnSourcesList setImageClickConfigs:@"ord_portugal_click.png"];
        
        IGEOButtonElement *btnNearMe = [[IGEOButtonElement alloc] init];
        [btnNearMe setName:@"bNearMe"];
        [btnNearMe setImageNormalConfigs:@"ord_perto_de_mim.png"];
        [btnNearMe setImageClickConfigs:@"ord_perto_de_mim_click.png"];
        
        IGEOButtonElement *btnExplore = [[IGEOButtonElement alloc] init];
        [btnExplore setName:@"bExplore"];
        [btnExplore setImageNormalConfigs:@"ord_explore.png"];
        [btnExplore setImageClickConfigs:@"ord_explore_click.png"];
        
        [result.btns addObject:btnSourcesList];
        [result.btns addObject:btnNearMe];
        [result.btns addObject:btnExplore];
        
        result.backgroundConf = [[NSMutableDictionary alloc] init];
        [result.backgroundConf setObject:@"ord_bg_cus.jpg" forKey:@"6"];
        [result.backgroundConf setObject:@"ord_bg_crus.jpg" forKey:@"7"];
        [result.backgroundConf setObject:@"ord_bg_home.jpg" forKey:@"-1"];
        result.subTitleBg = [IGEOConfigsManager getAppColor];
        result.urlTopImage = @"ord_header_ordenamento.png";
    }
    
    return result;
}


+(IGEOListSourcesScreenConfig *) getListSourcesScreenConfigs
{
    IGEOListSourcesScreenConfig *result = [[IGEOListSourcesScreenConfig alloc] init];
    
    if(APP_NAME==PATRIMONIO){
        result.urlTopImage = @"pat_img_default_patrimonio.jpg";
        result.colorSelection = [IGEOConfigsManager getAppConfigs].appColor;
    }
    if(APP_NAME==NATUREZA){
        result.urlTopImage = @"nat_img_default_patrimonio.jpg";
        result.colorSelection = [IGEOConfigsManager getAppConfigs].appColor;
    }
    if(APP_NAME==ORDENAMENTO){
        result.urlTopImage = @"ord_img_default_patrimonio.jpg";
        result.colorSelection = [IGEOConfigsManager getAppConfigs].appColor;
    }
    
    return result;
}


+(IGEOSelectLocationScreenConfigs *) getSelectLocationScreenConfigs
{
    IGEOSelectLocationScreenConfigs *result = [[IGEOSelectLocationScreenConfigs alloc] init];
    
    if(APP_NAME==PATRIMONIO){
        IGEOButtonElement *btnSelectionConfig = [[IGEOButtonElement alloc] init];
        [btnSelectionConfig setName:@"selection"];
        [btnSelectionConfig setImageNormalConfigs:@""];
        [btnSelectionConfig setImageClickConfigs:@""];
        result.bSelection = btnSelectionConfig;
        
        IGEOButtonElement *btnSearchConfig = [[IGEOButtonElement alloc] init];
        [btnSearchConfig setName:@"search"];
        [btnSearchConfig setImageNormalConfigs:@""];
        [btnSearchConfig setImageClickConfigs:@""];
        result.bSearch = btnSearchConfig;
        
        result.urlTopImage = @"pat_img_default_patrimonio.jpg";
    }
    if(APP_NAME==NATUREZA){
        IGEOButtonElement *btnSelectionConfig = [[IGEOButtonElement alloc] init];
        [btnSelectionConfig setName:@"selection"];
        [btnSelectionConfig setImageNormalConfigs:@""];
        [btnSelectionConfig setImageClickConfigs:@""];
        result.bSelection = btnSelectionConfig;
        
        IGEOButtonElement *btnSearchConfig = [[IGEOButtonElement alloc] init];
        [btnSearchConfig setName:@"search"];
        [btnSearchConfig setImageNormalConfigs:@""];
        [btnSearchConfig setImageClickConfigs:@""];
        result.bSearch = btnSearchConfig;
        
        result.urlTopImage = @"nat_img_default_patrimonio.jpg";
    }
    if(APP_NAME==ORDENAMENTO){
        IGEOButtonElement *btnSelectionConfig = [[IGEOButtonElement alloc] init];
        [btnSelectionConfig setName:@"selection"];
        [btnSelectionConfig setImageNormalConfigs:@""];
        [btnSelectionConfig setImageClickConfigs:@""];
        result.bSelection = btnSelectionConfig;
        
        IGEOButtonElement *btnSearchConfig = [[IGEOButtonElement alloc] init];
        [btnSearchConfig setName:@"search"];
        [btnSearchConfig setImageNormalConfigs:@""];
        [btnSearchConfig setImageClickConfigs:@""];
        result.bSearch = btnSearchConfig;
        
        result.urlTopImage = @"ord_img_default_patrimonio.jpg";
    }
    
    return result;
}


+(IGEOInfoScreenConfig *) getInfoSCreenConfigs
{
    IGEOInfoScreenConfig *result = [[IGEOInfoScreenConfig alloc] init];
    
    if(APP_NAME==PATRIMONIO){
        result.urlTopImage = @"pat_header_patrimonio.png";
    }
    if(APP_NAME==NATUREZA){
        result.urlTopImage = @"nat_header_natureza.png";
    }
    if(APP_NAME==ORDENAMENTO){
        result.urlTopImage = @"ord_header_ordenamento.png";
    }
    
    return result;
}


+(IGEOOptionsScreenConfig *) getOptionsScreenConfigs
{
    IGEOOptionsScreenConfig *result = [[IGEOOptionsScreenConfig alloc] init];
    
    if(APP_NAME==PATRIMONIO){
        result.buttonsOptionConf = [[NSMutableDictionary alloc] init];
        
        IGEOButtonElement *bDefaultCategory = [[IGEOButtonElement alloc] init];
        [bDefaultCategory setName:@"generic"];
        [bDefaultCategory setImageNormalConfigs:@"pat_cat_default.png"];
        [bDefaultCategory setImageClickConfigs:@"pat_cat_default_selected.png"];
        [result.buttonsOptionConf setObject:bDefaultCategory forKey:@"-1"];
        
        IGEOButtonElement *btnOkConfig = [[IGEOButtonElement alloc] init];
        [btnOkConfig setName:@"ok"];
        [btnOkConfig setImageNormalConfigs:@""];
        [btnOkConfig setImageClickConfigs:@""];
        result.okButtonConfig = btnOkConfig;
        
        result.urlTopImage = @"pat_header_patrimonio.png";
    }
    if(APP_NAME==NATUREZA){
        result.buttonsOptionConf = [[NSMutableDictionary alloc] init];
        
        IGEOButtonElement *bDefaultCategory = [[IGEOButtonElement alloc] init];
        [bDefaultCategory setName:@"generic"];
        [bDefaultCategory setImageNormalConfigs:@"nat_cat_default.png"];
        [bDefaultCategory setImageClickConfigs:@"nat_cat_default_selected.png"];
        [result.buttonsOptionConf setObject:bDefaultCategory forKey:@"-1"];
        
        IGEOButtonElement *btnOkConfig = [[IGEOButtonElement alloc] init];
        [btnOkConfig setName:@"ok"];
        [btnOkConfig setImageNormalConfigs:@""];
        [btnOkConfig setImageClickConfigs:@""];
        result.okButtonConfig = btnOkConfig;
        
        result.urlTopImage = @"nat_header_natureza.png";
    }
    if(APP_NAME==ORDENAMENTO){
        result.buttonsOptionConf = [[NSMutableDictionary alloc] init];
        
        IGEOButtonElement *bDefaultCategory = [[IGEOButtonElement alloc] init];
        [bDefaultCategory setName:@"generic"];
        [bDefaultCategory setImageNormalConfigs:@"ord_cat_default.png"];
        [bDefaultCategory setImageClickConfigs:@"ord_cat_default_selected.png"];
        [result.buttonsOptionConf setObject:bDefaultCategory forKey:@"-1"];
        
        IGEOButtonElement *btnOkConfig = [[IGEOButtonElement alloc] init];
        [btnOkConfig setName:@"ok"];
        [btnOkConfig setImageNormalConfigs:@""];
        [btnOkConfig setImageClickConfigs:@""];
        result.okButtonConfig = btnOkConfig;
        
        result.urlTopImage = @"ord_header_ordenamento.png";
    }
    
    return result;
}


+(IGEONativeMapScreenConfig *) getNativeMapScreenConfigs
{
    IGEONativeMapScreenConfig *result = [[IGEONativeMapScreenConfig alloc] init];

    if(APP_NAME==PATRIMONIO){
        result.colorPinsCategory = [[NSMutableDictionary alloc] init];
        result.colorHTMLCategory = [[NSMutableDictionary alloc] init];
        result.pinLegendCategory = [[NSMutableDictionary alloc] init];
        result.polygonColorCategory = [[NSMutableDictionary alloc] init];
        result.polygonBackgroundColorCategory = [[NSMutableDictionary alloc] init];
        
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"YELLOW_COLOR"] forKey:@"1"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"BLUE_COLOR"] forKey:@"2"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"MAGENTA_COLOR"] forKey:@"3"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"ORANGE_COLOR"] forKey:@"4"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"ROSE_COLOR"] forKey:@"5"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"VIOLET_COLOR"] forKey:@"6"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"GREEN_COLOR"] forKey:@"7"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"CYAN_COLOR"] forKey:@"8"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"AZURE_COLOR"] forKey:@"9"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"RED_COLOR"] forKey:@"0"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"CYAN_COLOR"] forKey:@"-1"];
        
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"YELLOW_PIN"] forKey:@"1"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"BLUE_PIN"] forKey:@"2"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"MAGENTA_PIN"] forKey:@"3"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"ORANGE_PIN"] forKey:@"4"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"ROSE_PIN"] forKey:@"5"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"VIOLET_PIN"] forKey:@"6"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"GREEN_PIN"] forKey:@"7"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"CYAN_PIN"] forKey:@"8"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"AZURE_PIN"] forKey:@"9"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"RED_PIN"] forKey:@"0"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"CYAN_PIN"] forKey:@"-1"];
    }
    if(APP_NAME==NATUREZA){
        result.colorPinsCategory = [[NSMutableDictionary alloc] init];
        result.colorHTMLCategory = [[NSMutableDictionary alloc] init];
        result.pinLegendCategory = [[NSMutableDictionary alloc] init];
        result.polygonColorCategory = [[NSMutableDictionary alloc] init];
        result.polygonBackgroundColorCategory = [[NSMutableDictionary alloc] init];
        
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"YELLOW_COLOR"] forKey:@"5"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"BLUE_COLOR"] forKey:@"6"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"MAGENTA_COLOR"] forKey:@"7"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"ORANGE_COLOR"] forKey:@"8"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"ROSE_COLOR"] forKey:@"9"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"VIOLET_COLOR"] forKey:@"0"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"GREEN_COLOR"] forKey:@"1"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"CYAN_COLOR"] forKey:@"2"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"AZURE_COLOR"] forKey:@"3"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"RED_COLOR"] forKey:@"4"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"CYAN_COLOR"] forKey:@"-1"];
        
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"YELLOW_PIN"] forKey:@"5"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"BLUE_PIN"] forKey:@"6"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"MAGENTA_PIN"] forKey:@"7"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"ORANGE_PIN"] forKey:@"8"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"ROSE_PIN"] forKey:@"9"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"VIOLET_PIN"] forKey:@"0"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"GREEN_PIN"] forKey:@"1"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"CYAN_PIN"] forKey:@"2"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"AZURE_PIN"] forKey:@"3"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"RED_PIN"] forKey:@"4"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"CYAN_PIN"] forKey:@"-1"];
    }
    if(APP_NAME==ORDENAMENTO){
        result.colorPinsCategory = [[NSMutableDictionary alloc] init];
        result.colorHTMLCategory = [[NSMutableDictionary alloc] init];
        result.pinLegendCategory = [[NSMutableDictionary alloc] init];
        result.polygonColorCategory = [[NSMutableDictionary alloc] init];
        result.polygonBackgroundColorCategory = [[NSMutableDictionary alloc] init];
        
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"YELLOW_COLOR"] forKey:@"8"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"BLUE_COLOR"] forKey:@"2"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"MAGENTA_COLOR"] forKey:@"3"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"ORANGE_COLOR"] forKey:@"4"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"ROSE_COLOR"] forKey:@"5"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"VIOLET_COLOR"] forKey:@"6"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"GREEN_COLOR"] forKey:@"7"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"CYAN_COLOR"] forKey:@"1"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"AZURE_COLOR"] forKey:@"9"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"RED_COLOR"] forKey:@"0"];
        [result.colorHTMLCategory setObject:[IGEOUtils getStringForKey:@"CYAN_COLOR"] forKey:@"-1"];
        
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"YELLOW_PIN"] forKey:@"8"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"BLUE_PIN"] forKey:@"2"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"MAGENTA_PIN"] forKey:@"3"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"ORANGE_PIN"] forKey:@"4"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"ROSE_PIN"] forKey:@"5"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"VIOLET_PIN"] forKey:@"6"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"GREEN_PIN"] forKey:@"7"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"CYAN_PIN"] forKey:@"1"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"AZURE_PIN"] forKey:@"9"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"RED_PIN"] forKey:@"0"];
        [result.pinLegendCategory setObject:[IGEOUtils getStringForKey:@"CYAN_PIN"] forKey:@"-1"];
    }
    
    return result;
}


+(IGEOListScreenConfig *) getListScreenConfigs
{
    IGEOListScreenConfig *result = [[IGEOListScreenConfig alloc] init];
    
    if(APP_NAME==PATRIMONIO){
        result.bgForSource = [[NSMutableDictionary alloc] init];
        [result.bgForSource setObject:@"pat_bg_pelourinho_right.jpg" forKey:@"1"];
        [result.bgForSource setObject:@"pat_bg_farois_right.jpg" forKey:@"2"];
        [result.bgForSource setObject:@"pat_bg_home_right.jpg" forKey:@"-1"];
        
        result.colorSelection = [IGEOConfigsManager getAppConfigs].appColor;
    }
    if(APP_NAME==NATUREZA){
        result.bgForSource = [[NSMutableDictionary alloc] init];
        [result.bgForSource setObject:@"nat_bg_flora_right.jpg" forKey:@"4"];
        [result.bgForSource setObject:@"nat_home_right.jpg" forKey:@"-1"];
        
        result.colorSelection = [IGEOConfigsManager getAppConfigs].appColor;
    }
    if(APP_NAME==ORDENAMENTO){
        result.bgForSource = [[NSMutableDictionary alloc] init];
        [result.bgForSource setObject:@"ord_bg_cus_right.jpg" forKey:@"6"];
        [result.bgForSource setObject:@"ord_bg_crus_right.jpg" forKey:@"7"];
        [result.bgForSource setObject:@"ord_bg_home_right.jpg" forKey:@"-1"];
        
        result.colorSelection = [IGEOConfigsManager getAppConfigs].appColor;
    }
    
    return result;
}


+(IGEODetailsScreenConfigs *) getDetailsScreenConfigs
{
    IGEODetailsScreenConfigs *result = [[IGEODetailsScreenConfigs alloc] init];
    
    if(APP_NAME==PATRIMONIO){
        result.defaultImageURL = @"pat_img_default_patrimonio.jpg";
    }
    if(APP_NAME==NATUREZA){
        result.defaultImageURL = @"nat_img_default_natureza.jpg";
    }
    if(APP_NAME==ORDENAMENTO){
        result.defaultImageURL = @"ord_img_default_ordenamento.jpg";
    }
    
    return result;
}

@end
