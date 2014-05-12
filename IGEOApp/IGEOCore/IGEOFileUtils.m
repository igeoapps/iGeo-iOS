//
//  IGEOFileUtils.m
//  IGEOApp
//
//  Created by Bitcliq on 14/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOFileUtils.h"

/*
 Esta classe contém os métodos necessários á manipulação de ficheiros. Isto é, leitura e escrita em ficheiros,
 * criação e listagem de diretorias, entre outros. É ainda utilizada para a obtenção das pastas onde iremos escrever e
 ler os ficheiros. Outra questão importante aqui, é que é nesta classe que se encontra o método que remove a opção de
 fazer backup dos ficheiros adicionados. Dado que a colocação na pasta na qual por defeito não são feitos backups, iria
 causar em situações em que a memória estivesse muito ocupada.
 */
@implementation IGEOFileUtils

/*
 Devolve o caminho para a pasta da aplicação.
 */
+(NSString *) rootPath {
    return [[NSBundle mainBundle] bundlePath];
}


/*
 Devolve o caminho para a pasta onde iremos guardar os ficheiros criados pela aplicação, ou seja, a pasta onde iremos
 colocar as imagens das quais fazemos o download e o ficheiro das configurações da App.
 */
+(NSString *) docsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}


/*
 Este método é utilizado para adicionar a um ficheiro a opção que indica ao sistema que não deverá fazer backup do mesmo.
 */
+(BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}


/*
 Escreve um conjunto de bytes num ficheiro indicando o caminho para o mesmo
 */
+(void) writeFileContent: (NSData *) data toPath: (NSString *) filePath {
    if (data) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
    }
}


/*
 Retorna YES ou NO consoante um ficheiro existe ou não nas imagens adicionadas ao projeto
 */
+(BOOL) fileExistsInResources:(NSString *) fileOriginalURL
{
    NSRange rangeBar = [fileOriginalURL rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *fileName = [fileOriginalURL substringFromIndex:rangeBar.location+1];
    NSString *fileURL = [[IGEOFileUtils docsPath] stringByAppendingPathComponent:fileName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:fileURL];
}


/*
 Retorna YES ou NO consoante um ficheiro, existe ou não na pasta onde estamos a guardar os ficheiros das imagens
 e das configurações
 */
+(BOOL) fileExists:(NSString *) fileName
{
    NSString *fileURL = [[IGEOFileUtils docsPath] stringByAppendingPathComponent:fileName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:fileURL];
}

@end
