//
//  IGEORelatedAppInfo.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Esta classe ainda não foi implementada nesta versão, no entanto, ela poderá permitir guardar a informação sobre
 uma App relacionada com a App atual, de forma a que possamos apresentar uma lista de outras Apps.
 */
@interface IGEORelatedAppInfo : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appURL;


-(id) initWithName:(NSString *) name URL:(NSString *) URL;

@end
