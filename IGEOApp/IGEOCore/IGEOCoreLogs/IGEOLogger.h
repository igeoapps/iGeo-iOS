//
//  IGEOLogger.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Classe com métodos estáticos usada para registar e fazer upload dos ultimos logs da aplicação.
 * Nesta versão esta funcionalidade não está implementada mas será implementada brevemente.
 */
@interface IGEOLogger : NSObject

+(BOOL) isLogsAtivated;
+(void) logAppEventForScreen:(NSString *) screenName forSource:(NSString *) sourceID forCategory:(NSString *) categoryID forItemID:(NSString *) itemID forAction:(NSString *) action;
+(BOOL) uploadLastLogs;

@end
