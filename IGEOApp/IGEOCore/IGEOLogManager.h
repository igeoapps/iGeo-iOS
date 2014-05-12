//
//  IGEOLogManager.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEOLogger.h"

/**
 Esta classe não foi ainda implementada, mas poderá de futuro ser utilizada para escrever e gerir os logs da aplicação.
 */
@interface IGEOLogManager : NSObject

@property (nonatomic, strong) IGEOLogger *appLogger;

+(void) logAppEventForScreen:(NSString *) screenName forSource:(NSString *) sourceID forCategory:(NSString *) categoryID forItemID:(NSString *) itemID forAction:(NSString *) action;

@end
