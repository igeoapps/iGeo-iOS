//
//  IGEOMapMarker.m
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IGEOMapMarker.h"

@implementation IGEOMapMarker

@synthesize coordinate = _coordinate;
@synthesize name = _name;
@synthesize resume = _resume;
@synthesize itemID = _itemID;
@synthesize categoryID = _categoryID;

-(id) initWithItemID:(NSString *) ID categoryID:(NSString *) categoryID name:(NSString *) name resume:(NSString *) resume coordenates:(CLLocation *) loc
{
	self = [super init];
	if (self != nil) {
        _coordinate.latitude = loc.coordinate.latitude;
        _coordinate.longitude = loc.coordinate.longitude;
        _name = name;
        _resume = resume;
        _itemID = ID;
        _categoryID = categoryID;
	}
	return self;
}

- (NSString *)subtitle
{
    if(_resume == nil)
        return @"";
    else
        return _resume;
}
- (NSString *)title
{
    if(_name == nil)
        return @"";
    else
        return _name;
}


@end
