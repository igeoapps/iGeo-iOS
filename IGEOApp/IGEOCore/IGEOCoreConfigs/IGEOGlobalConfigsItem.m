//
//  IGEOGlobalConfigsItem.m
//  IGEOApp
//
//  Created by Bitcliq on 29/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOGlobalConfigsItem.h"
#import "IGEOAppConfigs.h"

@implementation IGEOGlobalConfigsItem

@synthesize appConfigs = _appConfigs;
@synthesize screenConfigs = _screenConfigs;
@synthesize configsVersionDictionary = _configsVersionDictionary;

-(id) initWithAppConfigs:(IGEOAppConfigs *) appConf SCreenConfigs:(NSMutableDictionary *) screenConf configsVersionDictionary:(NSMutableDictionary *) confVersions {
    if ( self = [super init] ) {
        _appConfigs = appConf;
        _screenConfigs = screenConf;
        _configsVersionDictionary = confVersions;
    }
    return self;
}


/**
 O encode e decode é utilizado em todas as classes referenciadas nas configurações.
 Estamos aqui a utilizar o protocolo NSCoding para que possibilitar essa escrita em ficheiros.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_appConfigs forKey:@"appConfigs"];
    [coder encodeObject:_screenConfigs forKey:@"screenConfigs"];
    [coder encodeObject:_configsVersionDictionary forKey:@"configsVersionDictionary"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _appConfigs = [coder decodeObjectForKey:@"appConfigs"];
    _screenConfigs = [coder decodeObjectForKey:@"screenConfigs"];
    _configsVersionDictionary = [coder decodeObjectForKey:@"configsVersionDictionary"];
    return self;
}

@end
