//
//  IGEODataItemsCache.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEOGenericDataItem.h"

/**
 * Esta classe é útil na medida em que é utilizada para guardar os ultimos itens visitados. Ao tentar aceder
 * a um item vamos verificar se ele já se encontra nesta estrutura, e caso o mesmo aconteça vamos
 * apresentar a sua informação com base no objeto já guardado.
 * A limpeza neste momento é feita sempre que se atinge um máximo. No entanto,
 * de futuro seria preferivel implementar um método de limpeza que limpasse apenas os itens mais antigos deixando
 * os mais recentes disponíveis.
 */
@interface IGEODataItemsCache : NSObject

+(IGEOGenericDataItem *) getItem:(NSString *) ID;
+(void) addItem:(IGEOGenericDataItem *) item;
+(void) clear;

@end
