//
//  IGEOListSourcesScreenConfig.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOListSourcesScreenConfig.h"

@implementation IGEOListSourcesScreenConfig

@synthesize urlTopImage = _urlTopImage;
@synthesize colorSelection = _colorSelection;


/**
 O encode e decode é utilizado em todas as classes que são alojadas cas configs a serem guardadas no ficheiro de configurações da app.
 Estamos aqui a utilizar o protocolo NSCoding para que possibilidar essa escrita em ficheiros.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_urlTopImage forKey:@"urlTopImage"];
    [coder encodeObject:_colorSelection forKey:@"colorSelection"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _urlTopImage = [coder decodeObjectForKey:@"urlTopImage"];
    _colorSelection = [coder decodeObjectForKey:@"colorSelection"];
    return self;
}

@end
