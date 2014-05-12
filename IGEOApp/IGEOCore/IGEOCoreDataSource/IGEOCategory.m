//
//  IGEOCategory.m
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOCategory.h"

@implementation IGEOCategory

@synthesize categoryID = _categoryID;
@synthesize categoryName = _categoryName;
@synthesize categoryURL = _categoryURL;
@synthesize icon = _icon;
@synthesize iconSelected = _iconSelected;


-(NSString *) description
{
    NSString *result;
    
    result = [NSString stringWithFormat:@"Category (ID=%@, name=%@, icon=%@, iconSelected=%@)",_categoryID, _categoryName, _icon, _iconSelected];
    
    return result;
}


-(int) compareID:(NSString *) x
{
    if(x==nil)
        return 0;
    else {
        int id = [_categoryID intValue];
        int xInt = [x intValue];
        
        if(id>xInt)
            return 1;
        else
            return -1;
    }
}

@end
