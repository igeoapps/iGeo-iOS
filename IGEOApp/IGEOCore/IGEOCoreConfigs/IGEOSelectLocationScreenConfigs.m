//
//  IGEOSelectLocationScreenConfigs.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOSelectLocationScreenConfigs.h"

@implementation IGEOSelectLocationScreenConfigs

@synthesize urlTopImage = _urlTopImage;
@synthesize bSelection = _bSelection;
@synthesize bSearch = _bSearch;

/**
 O encode e decode é utilizado em todas as classes referenciadas nas configurações.
 Estamos aqui a utilizar o protocolo NSCoding para que possibilitar essa escrita em ficheiros.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_urlTopImage forKey:@"urlTopImage"];
    [coder encodeObject:_bSelection forKey:@"bSelection"];
    [coder encodeObject:_bSearch forKey:@"bSearch"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _urlTopImage = [coder decodeObjectForKey:@"urlTopImage"];
    _bSelection = [coder decodeObjectForKey:@"bSelection"];
    _bSearch = [coder decodeObjectForKey:@"bSearch"];
    return self;
}

@end
