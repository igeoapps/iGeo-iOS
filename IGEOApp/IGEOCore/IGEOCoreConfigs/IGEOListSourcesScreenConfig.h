//
//  IGEOListSourcesScreenConfig.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOScreenConfig.h"

/**
 Configurações de um ecrã para apresentação das fontes numa lista.
 */
@interface IGEOListSourcesScreenConfig : IGEOScreenConfig<NSCoding>

/**
 * URL da imagem de topo.
 */
@property (nonatomic, strong) NSString *urlTopImage;

/**
 * Cor da seleção dos itens da lista.
 */
@property (nonatomic, strong) NSString *colorSelection;

@end
