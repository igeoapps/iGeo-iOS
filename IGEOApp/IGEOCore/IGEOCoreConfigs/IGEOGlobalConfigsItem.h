//
//  IGEOGlobalConfigsItem.h
//  IGEOApp
//
//  Created by Bitcliq on 29/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEOAppConfigs.h"

/**
 * Esta classe é utilizada para guardar um conjunto de dados das configurações
 * Para guardar essas configurações é utilizado o protocolo NSCoding.
 */
@interface IGEOGlobalConfigsItem : NSObject<NSCoding>

@property (nonatomic, strong) IGEOAppConfigs *appConfigs;
@property (nonatomic, strong) NSMutableDictionary *screenConfigs;
@property (nonatomic, strong) NSMutableDictionary *configsVersionDictionary;

-(id) initWithAppConfigs:(IGEOAppConfigs *) appConf SCreenConfigs:(NSMutableDictionary *) screenConf configsVersionDictionary:(NSMutableDictionary *) confVersions;

@end
