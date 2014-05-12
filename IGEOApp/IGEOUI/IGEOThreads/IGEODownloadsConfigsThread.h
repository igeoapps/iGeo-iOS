//
//  IGEODownloadsConfigsThread.h
//  IGEOApp
//
//  Created by Bitcliq on 26/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGEOConfigDownloadItem.h"

/**
 Trata-se de uma thread que se encontra a correr em background sempre que a App esrteja em foreground, e que espera por pedidos
 para descarregar uma imagem.
 Após o descarregamento da imagem, consoante o seu tipo, a referência para a mesma é colocada no local correspondente das configurações.
 */
@interface IGEODownloadsConfigsThread : NSThread

/**
 * Representa o estado em que a thread se encontra. Os valores possíveis são:
 *   - Downloading: a descarregar uma imagem;
 *   - OnPause: á espera de um item para descarregar
 */
typedef enum {
    Downloading,
    OnPause
} IGEOThreadDownloadState;

/**
 * Array que serve de fila de espera para download de imagens.
 */
@property (nonatomic, strong) NSMutableArray *downloadItemsQueue;

/**
 * Item que está atualmente a ser descarregado.
 */
@property (nonatomic, strong) IGEOConfigDownloadItem *actualItem;

-(void) addItemToDownload:(IGEOConfigDownloadItem *) item;

@end
