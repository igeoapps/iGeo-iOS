//
//  IGEOOptionsScreenConfig.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOOptionsScreenConfig.h"

@implementation IGEOOptionsScreenConfig

@synthesize buttonsOptionConf = _buttonsOptionConf;
@synthesize okButtonConfig = _okButtonConfig;
@synthesize urlTopImage = _urlTopImage;

-(id)init {
    if ( self = [super init] ) {
        _buttonsOptionConf = [[NSMutableDictionary alloc] init];
    }
    return self;
}



/**
 O encode e decode é utilizado todas as classes que são referenciadas nas configurações e guardadas na app.
 Estamos aqui a utilizar o protocolo NSCoding para que possibilidar essa escrita em ficheiros.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_buttonsOptionConf forKey:@"buttonsOptionConf"];
    [coder encodeObject:_okButtonConfig forKey:@"okButtonConfig"];
    [coder encodeObject:_urlTopImage forKey:@"urlTopImage"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _buttonsOptionConf = [coder decodeObjectForKey:@"buttonsOptionConf"];
    _okButtonConfig = [coder decodeObjectForKey:@"okButtonConfig"];
    _urlTopImage = [coder decodeObjectForKey:@"urlTopImage"];
    return self;
}

@end
