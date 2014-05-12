//
//  IGEODetailsScreenConfigs.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEOScreenConfig.h"

@interface IGEODetailsScreenConfigs : IGEOScreenConfig<NSCoding>

/**
 * URL da imagem por defeito
 */
@property (nonatomic, strong) NSString *defaultImageURL;

@end
