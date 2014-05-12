//
//  IGEORelatedAppInfo.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEORelatedAppInfo.h"

@implementation IGEORelatedAppInfo

@synthesize appName = _appName;
@synthesize appURL = _appURL;

-(id) initWithName:(NSString *) name URL:(NSString *) URL{
    if ( self = [super init] ) {
        self.appName = name;
        self.appURL = URL;
    }
    return self;
}

@end
