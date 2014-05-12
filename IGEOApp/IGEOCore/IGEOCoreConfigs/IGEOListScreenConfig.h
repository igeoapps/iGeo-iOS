//
//  IGEOListScreenConfig.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOScreenConfig.h"

@interface IGEOListScreenConfig : IGEOScreenConfig<NSCoding>

/**
 * URL da imagem de fundo para cada fonte.
 */
@property (nonatomic, strong) NSMutableDictionary *bgForSource;

/**
 * Cor da seleção dos itens da lista.
 */
@property (nonatomic, strong) NSString *colorSelection;

@end
