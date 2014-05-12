//
//  IGEOButtonElement.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEOScreenElement.h"

/**
 * Configurações de um botão.
 */
@interface IGEOButtonElement : IGEOScreenElement<NSCoding>

/**
 * Nome do botão.
 */
@property (nonatomic, strong) NSString *name;

/**
 * URL da imagem do estado normal do botão.
 */
@property (nonatomic, strong) NSString *imageNormalConfigs;

/**
 * URL da imagem do estado seleccionado do botão.
 */
@property (nonatomic, strong) NSString *imageClickConfigs;

@end
