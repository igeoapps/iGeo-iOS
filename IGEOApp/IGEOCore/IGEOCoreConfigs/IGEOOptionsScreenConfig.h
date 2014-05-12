//
//  IGEOOptionsScreenConfig.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOScreenConfig.h"
#import "IGEOButtonElement.h"

/**
 Configurações de um ecrã de opções onde são selecionadas as categorias a apresentar.
 */
@interface IGEOOptionsScreenConfig : IGEOScreenConfig<NSCoding>

/**
 * Configuração usada para os botões de opções.
 * A cada chave do tipo srcID_catID corresponde a configuração de um botão
 */
@property (nonatomic, strong) NSMutableDictionary *buttonsOptionConf;

/**
 * Configuração do botão para ida para o mapa ou lista.
 */
@property (nonatomic, strong) IGEOButtonElement *okButtonConfig;

/**
 * URL da imagem de topo
 */
@property (nonatomic, strong) NSString *urlTopImage;

@end
