//
//  IGEOGenericDataItem.h
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEODataItem.h"
#import <CoreLocation/CoreLocation.h>

/**
 Item de dados comum com um título, um texto/html e uma imagem. Esta classe representa
 * um item de um tipo genérico, podendo o mesmo ser extendido de futuro para criar itens
 * com caracteristicas específicas mas que terão como base os atributos já aqui definidos.
 */
@interface IGEOGenericDataItem : IGEODataItem

/**
 * URL da imagem associada ao item.
 */
@property (nonatomic, strong) NSString *imageURL;

/**
 * Contém as coordenadas ou lista de coordenadas do item. No caso do item ser representado por um
 * polígono ou um grupo de polígonos este Array contém a lista de coordenadas.
 */
@property (nonatomic, strong) NSMutableArray *locationCoordenates;

/**
 * Idica se estamos perante um item que é uma lista de polígonos.
 */
@property (nonatomic) BOOL multiPolygon;

/**
 * Este Array é utilizado no caso dos itens que são representados por vários polígonos e indicam em que posição da lista
 * de coordenadas mudamos de poligono. Isto é, se tivermos um item em que as coordenadas da posição 0 até à 3 representam um polígono,
 * e as coordenadas da posição 4 à 7 outro poligono, este array list terá o seguinte conteúdo: [4, 7].
 */
@property (nonatomic, strong) NSMutableArray *lastPolygonCoordenates;

/**
 * Indica o centro do polígono. É neste ponto que será desenhado
 * o pin que permite o acesso através do mapa à informação do item.
 */
@property (nonatomic, strong) CLLocation *centerPoint;

@end
