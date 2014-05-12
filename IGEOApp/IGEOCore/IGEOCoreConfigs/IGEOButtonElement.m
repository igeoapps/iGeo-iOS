//
//  IGEOButtonElement.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOButtonElement.h"

@implementation IGEOButtonElement

@synthesize name = _name;
@synthesize imageNormalConfigs = _imageNormalConfigs;
@synthesize imageClickConfigs = _imageClickConfigs;

-(NSString *) description
{
    return [NSString stringWithFormat:@"ButtonElementConfig = (normal = %@, clicked = %@);", _imageNormalConfigs, _imageClickConfigs];
}


/**
 O encode e decode é utilizado em todas as classes referenciadas nas configurações.
 Estamos aqui a utilizar o protocolo NSCoding para que possibilitar essa escrita em ficheiros.
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_imageNormalConfigs forKey:@"imageNormalConfigs"];
    [coder encodeObject:_imageClickConfigs forKey:@"imageClickConfigs"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    _name = [coder decodeObjectForKey:@"name"];
    _imageNormalConfigs = [coder decodeObjectForKey:@"imageNormalConfigs"];
    _imageClickConfigs = [coder decodeObjectForKey:@"imageClickConfigs"];
    return self;
}

@end
