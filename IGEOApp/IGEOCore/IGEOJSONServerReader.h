//
//  IGEOJSONServerReader.h
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEODataItem.h"
#import "IGEOGenericDataItem.h"

/**
 Nesta classe temos métodos necessários para a obtenção dos dados através de consultas ao servidor e obtenção
 de um JSON do qual é feito o parsing e construídas as estruturas correspondentes instanciando classes do DataManager.
 Esta classe contém ainda variáveis estáticas onde são colocados temporariamente os dados lidos, para que os mesmos possam
 ser usados noutras classes
 */
@interface IGEOJSONServerReader : NSObject

/**
 Indica se ocorreu um erro na leitura do JSON. Isto é importante para que possamos verificar quando termina a operação de
 obtenção de dados, ou se ocorreu um erro no pedido
 */
@property (nonatomic) BOOL errorJSON;

/*
 Número tentativas para obter os dados de servidor
 */
@property (nonatomic) int times;

//Métodos de leitura do JSON
/**
 Lê as configurações dos itens por defeito da home, isto é, imagem de fundo da home e imagem de fundo da lista
 por defeito.
 */
+(void) readJSONAppDefaultsFromServer:(NSString *) URL;

/**
 Lê as fontes
 */
+(void) readJSONSourcesFromServer:(NSString *) URL clear:(BOOL) clear;

/**
    Lê as categorias
 */
+(void) readJSONCategoriesFromServer:(NSString *) URL;

/**
    Lê os itens.
 */
+(void) readJSONDataItemsFromServer:(NSString *) URL;

/**
 Lê os detalhes de um item.
 */
+(void) readJSONDataItemDetailsFromServer:(NSString *) URL;

//Métodos para acesso às variáveis estáticas acima indicadas
+(NSArray *) temporarySources;
+(NSArray *) temporaryCategories;
+(NSArray *) temporaryDataItems;
+(IGEODataItem *) temporaryDataItem;

//permite a alteração das variáveis estáticas acima indicadas
+(void) setTemporarySources:(NSArray *) list;
+(void) setTemporaryCategories:(NSArray *) list;
+(void) setTemporaryDataItems:(NSArray *) list;
+(void) setTemporaryDataItem:(IGEOGenericDataItem *) item;
+(void) clearTemporarydataItems;

@end
