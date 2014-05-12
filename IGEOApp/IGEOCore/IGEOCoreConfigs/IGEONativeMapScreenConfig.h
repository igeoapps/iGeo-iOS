//
//  IGEONativeMapScreenConfig.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOScreenConfig.h"

/**
 Configurações de um ecrã com um mapa.
 É aqui que vão ser colocadas as associações de cada par (fonte, categoria) a uma cor a apresentar no mapa,
 na legenda do mapa, nos polígonos do mapa, e nos títulos da lista.
 */
@interface IGEONativeMapScreenConfig : IGEOScreenConfig<NSCoding>

/**
 * Contém a associação a cada chave do tipo "srcID_catID" a uma NSString com o nome da imagem
 * a usar nos pins do mapa.
 */
@property (nonatomic, strong) NSMutableDictionary *colorPinsCategory;

/**
 * Contém a associação a cada chave do tipo "srcID_catID" a uma NSString contendo a cor em hexadecimal
 * a usar nos títulos da lista.
 */
@property (nonatomic, strong) NSMutableDictionary *colorHTMLCategory;

/**
 * Contém a associação a cada chave do tipo "srcID_catID" a uma NSString com o nome da imagem
 * a usar na legenda do mapa.
 */
@property (nonatomic, strong) NSMutableDictionary *pinLegendCategory;

//Cores a utilizar nos polígonos
@property (nonatomic, strong) NSMutableDictionary *polygonColorCategory;
@property (nonatomic, strong) NSMutableDictionary *polygonBackgroundColorCategory;

-(CGFloat) getPinColorForCategory:(NSString *) srcID cat:(NSString *) catID;
-(NSString *) getHTMLColorForCategory:(NSString *) srcID cat:(NSString *) catID;
-(NSString *) getPinLegendForCategory:(NSString *) srcID cat:(NSString *) catID;
-(NSNumber *) getPolygonColorForCategory:(NSString *) srcID cat:(NSString *) catID;
-(NSNumber *) getPolygonBackgroundColorForCategory:(NSString *) srcID cat:(NSString *) catID;

@end
