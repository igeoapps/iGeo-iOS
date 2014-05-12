//
//  IGEOFileUtils.h
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Esta classe contém os métodos necessários à manipulação de ficheiros. Isto é, leitura e escrita em ficheiros,
 * criação e listagem de diretorias, entre outros. É ainda utilizada para a obtenção das diretorias onde iremos escrever e
 ler os ficheiros. É nesta classe que se encontra o método que remove a opção de
 fazer backup dos ficheiros adicionados. 
 */
@interface IGEOFileUtils : NSObject

/*
 Devolve o caminho para a pasta da aplicação.
 */
+(NSString *) rootPath;


/*
 Devolve o caminho para a pasta onde iremos guardar os ficheiros criados pela aplicação, ou seja, a pasta onde iremos
 colocar as imagens das quais fazemos o download e o ficheiro das configurações da App.
 */
+(NSString *) docsPath;


/*
 Este método é utilizado para adicionar a um ficheiro a opção que indica ao sistema que não deverá fazer backup do mesmo.
 Ele será usado em todos os ficheiros que guardarmos, dado que, a não utilização desta opção faria com que esses ficheiros fossem
 transferidos como backup.
 */
+(BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

/*
 Escreve um conjunto de bytes num ficheiro indicando o caminho para o mesmo
 */
+(void) writeFileContent: (NSData *) data toPath: (NSString *) filePath;


/*
 Retorna YES ou NO consoante um ficheiro existe ou não nas imagens adicionadas ao projeto
 */
+(BOOL) fileExistsInResources:(NSString *) fileOriginalURL;

/*
 Retorna YES ou NO consoante um ficheir, existe ou não na pasta onde estamos a guardar os ficheiros das imagens
 e das configurações
 */
+(BOOL) fileExists:(NSString *) fileName;

@end
