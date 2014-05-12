//
//  IGEOSource.m
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOSource.h"
#import "IGEOCategory.h"

@implementation IGEOSource

@synthesize sourceID = _sourceID;
@synthesize sourcename = _sourcename;
@synthesize sourceURL = _sourceURL;
@synthesize color = _color;
@synthesize imageURL = _imageURL;
@synthesize srcSubtitle = _srcSubtitle;
@synthesize categoryDictionary = _categoryDictionary;
@synthesize imageListURL = _imageListURL;

-(id)init {
    if ( self = [super init] ) {
        //
        _categoryDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(id)initWithID:(NSString *) srcID Name:(NSString *) srcName URL:(NSString *) srcURL SubTitle:(NSString *) srcSubTitle {
    if ( self = [super init] ) {
        self.sourceID = srcID;
        self.sourcename = srcName;
        self.sourceURL = srcURL;
        self.srcSubtitle = srcSubTitle;
        _categoryDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(id)initWithID:(NSString *) srcID Name:(NSString *) srcName URL:(NSString *) srcURL SubTitle:(NSString *) srcSubTitle CatList:(NSArray *) catList {
    if ( self = [super init] ) {
        self.sourceID = srcID;
        self.sourcename = srcName;
        self.sourceURL = srcURL;
        self.srcSubtitle = srcSubTitle;
        _categoryDictionary = [[NSMutableDictionary alloc] init];
        
        for(IGEOCategory *c in catList)
        {
            [_categoryDictionary setObject:c forKey:c.categoryID];
        }
    }
    return self;
}




-(IGEOCategory *) getCategoryByID:(NSString *) ID
{
    if(_categoryDictionary!=nil){
        if([_categoryDictionary objectForKey:ID])
        {
            return [_categoryDictionary objectForKey:ID];
        }
    }
    
    return nil;
}



-(void) setCategories:(NSArray *) categories
{
    _categoryDictionary = [[NSMutableDictionary alloc] init];
    
    for(IGEOCategory *c in categories)
    {
        [_categoryDictionary setObject:c forKey:c.categoryID];
    }
}




-(NSString *) description
{
    NSString *result;
    
    result = [NSString stringWithFormat:@"Source (ID=%@, name=%@, imageURL=%@, categories=\n",_sourceID, _sourcename, _imageURL];
    
    for(IGEOCategory *c in [_categoryDictionary allValues])
    {
        result = [result stringByAppendingString:[NSString stringWithFormat:@"\t%@\n",[c description]]];
    }
    
    result = [result stringByAppendingString:@")\n\n"];
    
    return result;
}




-(int) compareID:(NSString *) x
{
    if(x==nil)
        return 0;
    else {
        int id = [_sourceID intValue];
        int xInt = [x intValue];
        
        if(id>xInt)
            return 1;
        else
            return -1;
    }
}

@end
