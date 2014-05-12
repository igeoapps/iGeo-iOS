//
//  OALocation.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOLocation.h"

@implementation IGEOLocation


@synthesize ID = _ID;
@synthesize name = _name;


- (id)initWithID:(int)ID name:(NSString *)name
{
    self.ID = ID;
    self.name = name;
    return self;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"IGEOLocation (ID = %d, name = %@)", _ID, _name];
}

@end
