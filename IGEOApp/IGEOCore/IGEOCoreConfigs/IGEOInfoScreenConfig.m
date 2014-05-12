//
//  IGEOInfoScreenConfig.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOInfoScreenConfig.h"

@implementation IGEOInfoScreenConfig

@synthesize urlTopImage = _urlTopImage;


/**
 O encode e decode é utilizado em todas as classes referenciadas nas configurações.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_urlTopImage forKey:@"urlTopImage"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _urlTopImage = [coder decodeObjectForKey:@"urlTopImage"];
    return self;
}

@end
