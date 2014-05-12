//
//  OADistritoViewController.h
//  IGEOApp
//
//  Created by Bitcliq on 17/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ViewController que é lançado para apresentação de uma lista de distritos, concelhos ou freguesias,
 permitindo após isso a seleção do item pretendido.
 */
@interface IGEOQueryParamsViewController : UITableViewController

/**
 Conteúdo da lista a apresentar.
 */
@property (strong, nonatomic) NSArray *content;

@end
