//
//  IGEOListScreenConfig.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOListScreenConfig.h"

@implementation IGEOListScreenConfig

@synthesize bgForSource = _bgForSource;
@synthesize colorSelection = _colorSelection;


/**
 O encode e decode é utilizado em todas as classes referenciadas nas configurações.
 Estamos aqui a utilizar o protocolo NSCoding para que possibilitar essa escrita em ficheiros.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_bgForSource forKey:@"bgForSource"];
    [coder encodeObject:_colorSelection forKey:@"colorSelection"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _bgForSource = [coder decodeObjectForKey:@"bgForSource"];
    _colorSelection = [coder decodeObjectForKey:@"colorSelection"];
    return self;
}

@end
