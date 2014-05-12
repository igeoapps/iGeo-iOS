//
//  IGEOInfoScreenConfig.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOScreenConfig.h"

/**
 Configurações de um ecrã para página de informação do projecto.
 */
@interface IGEOInfoScreenConfig : IGEOScreenConfig<NSCoding>

/**
 Imagem de topo.
 */
@property (nonatomic, strong) NSString *urlTopImage;

@end
