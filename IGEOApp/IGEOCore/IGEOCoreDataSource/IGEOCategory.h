//
//  IGEOCategory.h
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Esta classe contém informação sobre uma categoria, podendo ou não ter subcategorias dependendo se o arraylist
 categoryList é ou não null.
 */
@interface IGEOCategory : NSObject

/**
 * Usado para identificar de forma única uma categoria.
 */
@property (nonatomic, strong) NSString *categoryID;

/**
 * Nome da categoria.
 */
@property (nonatomic, strong) NSString *categoryName;

/**
 * URL usado para aceder à categoria.
 */
@property (nonatomic, strong) NSString *categoryURL;

/**
 * Nome do ícone usado na escolha de categorias para representar a mesma. Caso este nome não seja precedido
 * de "/" será considerado um ficheiro contido no projeto.
 */
@property (nonatomic, strong) NSString *icon;


/**
 * Nome do ícone (modo seleccionado) usado na escolha de categorias para representar a mesma. Caso este nome não seja precedido
 * de "/" será considerado um ficheiro contido no projeto.
 */
@property (nonatomic, strong) NSString *iconSelected;


/**
 É utilizado para que seja possível uma comparação entre categorias, possibilitando assima sua ordenação por ID.
 */
-(int) compareID:(NSString *) x;

@end
