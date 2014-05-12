//
//  IGEOConfigDownloadItem.h
//  IGEOApp
//
//  Created by Bitcliq on 26/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Esta classe é utilizada para guardar a informação correspondente a um item que pretendemos descarregar e colocar nas configs
 dos ecrãs da App.
 */
@interface IGEOConfigDownloadItem : NSObject

/**
 * Representa o tipo do item que pretendemos descarregar. Os valores possíveis são:
 *  - HomeBgImage: Imagem de fundo do ecrã da Home.
 *  - ListBGImage: Imagem de fundo do ecrã da lista de itens.
 *  - CatIconNormal: Imagem para o estado normal do icone de uma categoria utilizado no ecrã de seleção de categorias.
 *  - CatIconSelected: Imagem para o estado selecionado do icone de uma categoria utilizado no ecrã de seleção de categorias.
 *  - CatPinImage: Imagem do pin usado na legenda do mapa para uma categoria.
 */
typedef enum {
    HomeBgImage,
    ListBGImage,
    CatIconNormal,
    CatIconSelected,
    CatPinImage
} IGEODonwloadItemType;

@property (nonatomic, strong) NSString *url;

/**
 Nome que terá a imagem final guardada no dispositivo
 */
@property (nonatomic, strong) NSString *destinationFolder;
@property (nonatomic, strong) NSString *srcID;
@property (nonatomic, strong) NSString *catID;

/**
 Tipo do item.
 */
@property (nonatomic) IGEODonwloadItemType type;

-(id) initWithURL:(NSString *) URL destinationFolder:(NSString *) destination source:(NSString *) sID category:(NSString *) cID type:(IGEODonwloadItemType) t;

@end
