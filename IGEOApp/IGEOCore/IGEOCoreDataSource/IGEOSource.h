//
//  IGEOSource.h
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Esta classe contém a informação sobre uma fonte de dados. 
 */
@interface IGEOSource : NSObject

/**
 * Identifica a fonte
 */
@property (nonatomic, strong) NSString *sourceID;

/**
 * Nome da fonte.
 */
@property (nonatomic, strong) NSString *sourcename;

/**
 * URL usado para aceder à fonte.
 */
@property (nonatomic, strong) NSString *sourceURL;

/**
 * hashMap de categorias da source indexadas pelo seu ID.
 */
@property (nonatomic, strong) NSMutableDictionary *categoryDictionary;

/**
 Cor associada à fonte.
 */
@property (nonatomic, strong) NSString *color;

/**
 * Será usada para receber do servidor o url da imagem a usar como fundo na home quando
 * estamos a vizualizar dados desta fonte.
 */
@property (nonatomic, strong) NSString *imageURL;

/**
 * Será usada para receber do servidor o url da imagem a usar como fundo na lista quando
 * estamos a vizualizar dados desta fonte.
 */
@property (nonatomic, strong) NSString *imageListURL;
@property (nonatomic, strong) NSString *srcSubtitle;

@end
