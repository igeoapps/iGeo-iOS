//
//  IGEODataItemsCache.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEODataItemsCache.h"

@implementation IGEODataItemsCache

/**
 * Número máximo de elementos a serem guardados
 */
static const int MAX_ELEMENTS = 50;

/**
 * HashMap que contém os itens, tendo como key o seu ID
 */
static NSMutableDictionary *items;


/**
 Método usado para obter um item dado o seu ID.
 */
+(IGEOGenericDataItem *) getItem:(NSString *) ID
{
    if(items!=nil){
        return [items objectForKey:ID];
    }
    
    return nil;
}


/**
 Adiciona um item à lista de itens.
 */
+(void) addItem:(IGEOGenericDataItem *) item
{
    if(items==nil)
        items = [[NSMutableDictionary alloc] init];
    
    if([items count]>MAX_ELEMENTS){
        [IGEODataItemsCache clear];
    }
}


/**
 Elimina da estrutura todos os itens carregados até ao momento.
 */
+(void) clear
{
    [items removeAllObjects];
}

@end
