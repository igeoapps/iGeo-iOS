//
//  IGEOGenericDataItem.m
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOGenericDataItem.h"

@implementation IGEOGenericDataItem

@synthesize imageURL = _imageURL;
@synthesize locationCoordenates = _locationCoordenates;
@synthesize multiPolygon = _multiPolygon;
@synthesize lastPolygonCoordenates = _lastPolygonCoordenates;
@synthesize centerPoint = _centerPoint;

-(id)init {
    if ( self = [super init] ) {
        //
        _locationCoordenates = [[NSMutableArray alloc] init];
        _lastPolygonCoordenates = [[NSMutableArray alloc] init];
    }
    return self;
}


-(NSString *) description
{
    NSString *result = [NSString stringWithFormat:@"DataItem (ID:%@, Resume: %@, CategoryID:%@, Image_URL:%@, Titulo%@, GPS:", self.itemID, self.textOrHTML,
                        self.categoryID, self.imageURL, self.title];
    
    if(_locationCoordenates!=nil){
        for(CLLocation *l in _locationCoordenates)
        {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"(%f, %f) ", l.coordinate.latitude, l.coordinate.longitude]];
        }
    }
    
    return result;
}

@end
