//
//  IGEODataItem.h
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Classe que representa um item de dados contido numa categoria de uma fonte.
 */
@interface IGEODataItem : NSObject


/**
 * Usado para identificar de forma única o item.
 */
@property (nonatomic, strong) NSString *itemID;

/**
 * Título do item a ser apresentado na lista, balão do mapa e detalhes.
 */
@property (nonatomic, strong) NSString *title;

/**
 * URL de acesso ao item.
 */
@property (nonatomic, strong) NSString *itemURL;

/**
 * Pode conter um texto simples ou HTML acerca do item.
 */
@property (nonatomic, strong) NSString *textOrHTML;

/**
 * ID da categoria a que o item pertence.
 */
@property (nonatomic, strong) NSString *categoryID;

@end
