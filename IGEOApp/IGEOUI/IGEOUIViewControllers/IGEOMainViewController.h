//
//  IGEOMainViewController.h
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGEOSearchButton.h"
#import "IGEOConfigurableViewController.h"

/**
 * ViewController inicial que contém as principais opções da App.
 * Esta atividade agrupa três ecrãs inicialmente criados, devido ao efeito que se pretende. Teremos o ecrã com os botões da home,
 * mais a esquerda na scrollView teremos a lista de categorias e à direita teremos a lista de itens. A transição entre os ecrãs
 * é feita pelo deslocamento de uma scrollview programaticamente no clique de cada um dos três botões do ecrã inicial.
 * Futuramente o modo como o efeito é feito poderá ser alterado.
 */

@interface IGEOMainViewController : UIViewController<UIAlertViewDelegate, IGEOConfigurable>
@property (strong, nonatomic) IBOutlet UIButton *bSourcesList;
@property (strong, nonatomic) IBOutlet UIButton *bNearMe;
@property (strong, nonatomic) IBOutlet UIButton *bExplore;
@property (strong, nonatomic) IBOutlet UILabel *tTitle;
@property (strong, nonatomic) IBOutlet UILabel *tOpenGeograficData;
@property (strong, nonatomic) IBOutlet UILabel *tSubtitle;

@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBg;

@property (strong, nonatomic) IBOutlet UIButton *bBack;
@property (strong, nonatomic) IBOutlet UIButton *bInfo;

@property (strong, nonatomic) IBOutlet UITableView *tableSources;
@property (strong, nonatomic) IBOutlet IGEOSearchButton *bDistricts;
@property (strong, nonatomic) IBOutlet IGEOSearchButton *bCouncils;
@property (strong, nonatomic) IBOutlet IGEOSearchButton *bParishes;
@property (strong, nonatomic) IBOutlet IGEOSearchButton *bSearch;

@property (strong, nonatomic) IBOutlet UILabel *tDistricts;
@property (strong, nonatomic) IBOutlet UILabel *tCouncils;
@property (strong, nonatomic) IBOutlet UILabel *tParishes;

@property (nonatomic) BOOL sourcesExists;
@property (nonatomic) BOOL backExplore;

@property (strong, nonatomic) IBOutlet UILabel *tSources;
@property (strong, nonatomic) IBOutlet UILabel *tNearMe;
@property (strong, nonatomic) IBOutlet UILabel *tExplore;

@property (strong, nonatomic) IBOutlet UIImageView *topView;

@property (strong, nonatomic) IBOutlet UIView *viewLoading;
@property (strong, nonatomic) IBOutlet UIButton *bBackLoadingView;

@property (strong, nonatomic) IBOutlet UILabel *tLoadingMessage;



@end
