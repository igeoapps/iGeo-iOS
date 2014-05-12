//
//  IGEOOptionsViewController.h
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGEOConfigurableViewController.h"

/**
 * ViewController com uma lista de opções. Pode ser usada após o clique no "perto de mim" ou no "explore".
 * Na apresentação das categorias temos duas listas, cada uma delas correspondente a  uma das colunas onde são colocados ícones de categorias.
 * A opção tomada para a apresentação das categorias em duas colunas foi a da criação de duas listas. 
 */
@interface IGEOOptionsViewController : UIViewController<UIAlertViewDelegate, IGEOConfigurable>

@property (strong, nonatomic) IBOutlet UIButton *bInfo;

//Indica se viemos do explore
@property (nonatomic) BOOL fromExplore;

@property (strong, nonatomic) IBOutlet UIButton *bBack;
@property (strong, nonatomic) IBOutlet UITableView *listOptions1;
@property (strong, nonatomic) IBOutlet UITableView *listOptions2;
@property (strong, nonatomic) IBOutlet UIButton *bOk;
@property (strong, nonatomic) IBOutlet UIButton *bOkList;
@property (strong, nonatomic) IBOutlet UILabel *tSubtitle;
@property (strong, nonatomic) IBOutlet UILabel *tSelectCategories;
@property (strong, nonatomic) IBOutlet UIImageView *topView;
@property (nonatomic) BOOL isStartingLocationNow;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIButton *loadingBackButton;
@property (strong, nonatomic) IBOutlet UIView *mainContainerView;
@property (strong, nonatomic) IBOutlet UILabel *tloadingMessage;


@end
