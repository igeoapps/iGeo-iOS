//
//  IGEOAppConfigs.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Classe usada para guardar as configurações da App atual.
 */
@interface IGEOAppConfigs : NSObject<NSCoding>

/**
 * Contém o raio pré-definido usado na pesquisa por proximidade.
 */
@property (nonatomic) int proximityRadius;

/**
 * HashMap de fontes disponíveis na App, indexadas pelo seu ID.
 */
@property (nonatomic, strong) NSMutableDictionary *appSourcesHashMap;

/**
 * Nome da App.
 */
@property (nonatomic, strong) NSString *appName;

/**
 * Nome do package da App.
 */
@property (nonatomic, strong) NSString *appPackageName;

/**
 * URL usado para pedidos ao servidor.
 */
@property (nonatomic, strong) NSString *URLRequests;

/**
 * URL usado para pedir ao servidor as fontes disponíveis para esta App.
 */
@property (nonatomic, strong) NSString *URLRequestsSources;

/**
 * URL usado para pedir ao servidor as categorias disponíveis nesta App para uma determinada fonte.
 */
@property (nonatomic, strong) NSString *URLRequestsCategories;

/**
 * URL usado para pedir ao servidor as configurações por defeito para esta App.
 */
@property (nonatomic, strong) NSString *URLRequestAppDefaults;

/**
 * Cor base da App.
 */
@property (nonatomic, strong) NSString *appColor;

-(id)initWithAppName:(NSString *) name PackageName:(NSString *) pkName URLUpdate:(NSString *) URL;
-(void) setSourcesList:(NSArray *) list;

@end
