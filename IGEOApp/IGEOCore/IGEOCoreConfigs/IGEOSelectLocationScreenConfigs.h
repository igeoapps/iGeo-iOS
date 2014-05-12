//
//  IGEOSelectLocationScreenConfigs.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOScreenConfig.h"
#import "IGEOButtonElement.h"

/**
 Elemento genérico que representa a configuração de um ecrã. Esta classe deverá ser extendida por outras classes.
 */
@interface IGEOSelectLocationScreenConfigs : IGEOScreenConfig<NSCoding>

/**
 * URL da imagem de topo
 */
@property (nonatomic, strong) NSString *urlTopImage;

/**
 * Configurações do botão de seleção do distrito, concelho e freguesia
 */
@property (nonatomic, strong) IGEOButtonElement *bSelection;

/**
 * Configurações do botão de pesquisa
 */
@property (nonatomic, strong) IGEOButtonElement *bSearch;

@end
