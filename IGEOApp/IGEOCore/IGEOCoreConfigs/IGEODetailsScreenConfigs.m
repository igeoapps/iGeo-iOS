//
//  IGEODetailsScreenConfigs.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEODetailsScreenConfigs.h"

@implementation IGEODetailsScreenConfigs

@synthesize defaultImageURL = _defaultImageURL;


/**
 O encode e decode é utilizado em todas as classes referenciadas nas configurações.
 Estamos aqui a utilizar o protocolo NSCoding para que possibilitar essa escrita em ficheiros.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_defaultImageURL forKey:@"defaultImageURL"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _defaultImageURL = [coder decodeObjectForKey:@"defaultImageURL"];
    return self;
}

@end
