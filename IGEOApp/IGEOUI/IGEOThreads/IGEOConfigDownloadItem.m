//
//  IGEOConfigDownloadItem.m
//  IGEOApp
//
//  Created by Bitcliq on 26/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOConfigDownloadItem.h"

@implementation IGEOConfigDownloadItem

@synthesize url = _url;
@synthesize destinationFolder = _destinationFolder;
@synthesize srcID = _srcID;
@synthesize catID = _catID;
@synthesize type = _type;

-(id) initWithURL:(NSString *) URL destinationFolder:(NSString *) destination source:(NSString *) sID category:(NSString *) cID type:(IGEODonwloadItemType) t {
    if ( self = [super init] ) {
        _url = URL;
        _destinationFolder = destination;
        _srcID = sID;
        _catID = cID;
        _type = t;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"IGEOConfigDownloadItem (url = %@, destinationFolder = %@, srcID = %@, catID = %@, type = %d)",
            _url,
            _destinationFolder,
            _srcID,
            _catID,
            _type];
}

@end
