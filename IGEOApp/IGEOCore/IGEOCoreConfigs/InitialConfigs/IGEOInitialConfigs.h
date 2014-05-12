//
//  IGEOInitialConfigs.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEOAppConfigs.h"
#import "IGEOScreenConfig.h"
#import "IGEOHomeScreenConfigs.h"
#import "IGEOListSourcesScreenConfig.h"
#import "IGEOSelectLocationScreenConfigs.h"
#import "IGEOOptionsScreenConfig.h"
#import "IGEONativeMapScreenConfig.h"
#import "IGEOListScreenConfig.h"
#import "IGEODetailsScreenConfigs.h"
#import "IGEOInfoScreenConfig.h"

/**
 Esta classe cria uma estrutura que as configurações iniciais da app na primeira vez que esta é executada.
 Estas configurações são depois utilizadas pelo ConfigsManager.
 */
@interface IGEOInitialConfigs : NSObject


//Os métodos aqui declarados são utilizados para obter a configurações de cada um dos ecrãs.
+(IGEOAppConfigs *) getAppConfigs;
+(IGEOHomeScreenConfigs *) getHomeScreenConfigs;
+(IGEOListSourcesScreenConfig *) getListSourcesScreenConfigs;
+(IGEOSelectLocationScreenConfigs *) getSelectLocationScreenConfigs;
+(IGEOInfoScreenConfig *) getInfoSCreenConfigs;
+(IGEOOptionsScreenConfig *) getOptionsScreenConfigs;
+(IGEONativeMapScreenConfig *) getNativeMapScreenConfigs;
+(IGEOListScreenConfig *) getListScreenConfigs;
+(IGEODetailsScreenConfigs *) getDetailsScreenConfigs;

@end
