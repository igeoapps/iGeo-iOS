//
//  OALocation.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Representa de modo genérico uma localização, que depois pode ser mais específica, ou seja, poderá
 ser um distrito, um concelho ou uma freguesia.
 */
@interface IGEOLocation : NSObject

- (id)initWithID:(int)ID name:(NSString *)name;

@property (nonatomic) int ID;
@property (nonatomic, strong) NSString *name;


@end
