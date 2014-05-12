//
//  IGEOLogger.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOLogger.h"

@implementation IGEOLogger

static BOOL isLogsAtivated;


+(BOOL) isLogsAtivated
{
    return isLogsAtivated;
}


+(void) logAppEventForScreen:(NSString *) screenName forSource:(NSString *) sourceID forCategory:(NSString *) categoryID forItemID:(NSString *) itemID forAction:(NSString *) action
{
    
}


+(BOOL) uploadLastLogs
{
    return NO;
}

@end
