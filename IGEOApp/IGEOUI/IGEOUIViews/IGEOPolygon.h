//
//  IGEOPolygon.h
//  IGEOApp
//
//  Created by Bitcliq on 17/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <MapKit/MapKit.h>

/**
 Esta classe é utilizada para representar um polígono a desenhar no mapa.
 A criação de uma classe customizada permite adicionar algumas informações necessárias e que não
 existem por defeito na classe MKPolygon.
 */
@interface IGEOPolygon : MKPolygon

@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *categoryID;

@end
