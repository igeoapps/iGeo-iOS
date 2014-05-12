//
//  IGEOConfigsManager.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEOAppConfigs.h"
#import "IGEOScreenConfig.h"

/**
 Esta classe é responsável por ler e gerir as configurações internas da App, e as configurações da UI
 quando utilizadas. Contém métodos estáticos que retornam configurações para a App e para cada ecrã.
 */
@interface IGEOConfigsManager : NSObject

+(NSString *) getAppName;
+(NSString *) getAppPackage;

+(IGEOAppConfigs *) getAppConfigs;
+(NSDictionary *) getScreensConfigs;
+(void) setScreenConfig:(NSString *) screen config:(IGEOScreenConfig *) config;
+(void) applyCurrentConfigs;
+(NSString *) getBackgroundImageForSource:(NSString *) srcID;
+(NSString *) getBackgroundRightImageForSource:(NSString *) srcID;
+(NSString *) getIconForSource:(NSString *) sourceID AndCategory:(NSString *) categoryID;
+(NSString *) getIconForSource:(NSString *) sourceID AndCategorySelected:(NSString *) categoryID;
+(NSString *) getColorForHTMLCategory:(NSString *) categoryID;
+(NSString *) getPinIconForCategory:(NSString *) categoryID;
+(NSString *) getTopImage;
+(NSString *) getAppTitle;
+(NSMutableArray *) getHomeIcons;
+(NSMutableArray *) getHomeIconsClicked;
+(NSString *) getListsSelectionColor;
+(NSString *) getAppColor;
+(NSString *) getSubtitleBackground;
+(NSString *) getDefaultImage;

+(void) changeTitleListColorForSource:(NSString *) srcID AndCategory:(NSString *) catID color:(NSString *) color;
+(void) changePolygonLineColorForSource:(NSString *) srcID AndCategory:(NSString *) catID color:(NSString *) color;
+(void) changePolygonBackgroundColorForSource:(NSString *) srcID AndCategory:(NSString *) catID color:(NSString *) color;
+(void) changePinMapImageForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url;
+(void) changeCategoryIconNormalForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url;
+(void) changeCategoryIconNormalForSource:(NSString *) srcID defaultUrl:(NSString *) url;
+(void) changeCategoryIconSelectedForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url;
+(void) changeCategoryIconSelectedForSource:(NSString *) srcID defaultUrl:(NSString *) url;

+(void) changeBackgroundImageHomeForSource:(NSString *) srcID url:(NSString *) url;
+(void) changeBackgroundImageHomeDefaultUrl:(NSString *) url;
+(void) changeBackgroundImageListForSource:(NSString *) srcID url:(NSString *) url;
+(void) changeBackgroundImageListDefaultUrl:(NSString *) url;



+(void) setHomeBgImageForSource:(NSString *) srcID url:(NSString *) url;
+(void) setListBgImageForSource:(NSString *) srcID url:(NSString *) url;
+(void) setCatIconNormalForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url;
+(void) setCatIconSelectedForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url;
+(void) setCatPinImageForSource:(NSString *) srcID AndCategory:(NSString *) catID url:(NSString *) url;





+(NSMutableDictionary *) configsVersionDictionary;
+(int) getVersionNumberForAppDefaults;
+(void) setVersionNumberForAppDefaults:(int) version;
+(int) getVersionNumberForSource:(NSString *) srcID;
+(void) setVersionNumber:(int) version ForSource:(NSString *) srcID;
+(int) getVersionNumberForSource:(NSString *) srcID AndCategory:(NSString *) catID;
+(void) setVersionNumber:(int) version ForSource:(NSString *) srcID AndCategory:(NSString *) catID;




+(void) readDefaultConfigs;
+(void) writeDefaultConfigs;

@end
