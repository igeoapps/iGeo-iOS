//
//  IGEOHomeScreenConfigs.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOScreenConfig.h"
#import "IGEOButtonElement.h"

/**
 Configurações de um ecrã home.
 */
@interface IGEOHomeScreenConfigs : IGEOScreenConfig

/**
 * Configuração da imagem de fundo para cada uma das fontes.
 * Esta variável é um HashMap que associa a cada fonte o URL/caminho de uma imagem de fundo.
 */
@property (nonatomic, strong) NSMutableDictionary *backgroundConf;

/**
 * URL da imagem de topo.
 */
@property (nonatomic, strong) NSString *urlTopImage;

/**
 * Configurações dos botões da home.
 */
@property (nonatomic, strong) NSMutableArray *btns;

/**
 * URL para o fundo do subtítulo.
 */
@property (nonatomic, strong) NSString *subTitleBg;

-(NSString *) getBackgroundImageForCategoryName:(NSString *) srcID;
-(NSMutableArray *) getBtnsNormal;
-(NSMutableArray *) getBtnsClicked;

@end
