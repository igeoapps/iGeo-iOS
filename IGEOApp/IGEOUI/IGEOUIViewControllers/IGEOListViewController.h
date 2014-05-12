//
//  IGEOListViewController.h
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGEOConfigurableViewController.h"

/**
 * Esta atividade apresenta uma lista de itens com o seu name e uma breve descrição. Contém ainda a possíbilidade de pesquisar por
 * palavras chave, ir para o mapa e voltar para a Home.
 */
@interface IGEOListViewController : UIViewController<UIAlertViewDelegate, IGEOConfigurable, UITextFieldDelegate>

//tabela onde estão os DataItems
@property (strong, nonatomic) IBOutlet UITableView *tableDataItems;

@property (strong, nonatomic) IBOutlet UIButton *bBack;
@property (strong, nonatomic) IBOutlet UIButton *bHome;
@property (strong, nonatomic) IBOutlet UIButton *bMap;
@property (strong, nonatomic) IBOutlet UITextField *tSearch;
@property (strong, nonatomic) IBOutlet UIButton *bSearch;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;

//Estas variáveis são importantes para sabermos se o utilizador veio do explore ou do mapa
//As ações de back e de clique no mapa dependem do valor das mesmas.
@property (nonatomic) BOOL fromExplore;
@property (nonatomic) BOOL fromMap;
//--

//textView onde é apresentado o número de resultados
@property (strong, nonatomic) IBOutlet UILabel *tResults;
@property (strong, nonatomic) IBOutlet UILabel *tSubtitle;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIButton *bBackLoadingView;
@property (strong, nonatomic) IBOutlet UILabel *tLoadingMessage;


@property (strong, nonatomic) IBOutlet UIView *topView;

+(BOOL) getReloadData;
+(void) setReloadData:(BOOL) r;

@end
