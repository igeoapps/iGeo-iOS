//
//  IGEODetailsViewController.h
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGEOConfigurableViewController.h"
#import "SDWebImageDownloaderDelegate.h"
#import <MessageUI/MessageUI.h>

/**
 * ViewController que apresenta os detalhes de um item
 * A imagem é obtida através de um link e colocada numa UIImageView. As strings relativas à fonte, categoria
 * e o título do item são carregados em TextView's, e a restante informação é carregada utilizando HTML, e CSS's
 * que se encontram na pasta IGEOStyles, o qual contém uma lista de pares atributo-valor.
 */

@interface IGEODetailsViewController : UIViewController<UIAlertViewDelegate, IGEOConfigurable, UIWebViewDelegate, SDWebImageDownloaderDelegate, MFMailComposeViewControllerDelegate>

//Botões de topo
@property (strong, nonatomic) IBOutlet UIButton *bBack;
@property (strong, nonatomic) IBOutlet UIButton *bHome;
@property (strong, nonatomic) IBOutlet UIButton *bBackViewLoading;
@property (strong, nonatomic) IBOutlet UIButton *bShare;

/**
 Identificador do item que será apresentado
 */
@property (nonatomic, strong) NSString *itemID;

//view's para apresentação do conteúdo do item
@property (strong, nonatomic) IBOutlet UILabel *tTitle;
@property (strong, nonatomic) IBOutlet UILabel *tSource;
@property (strong, nonatomic) IBOutlet UILabel *tCategory;
@property (strong, nonatomic) IBOutlet UIWebView *webViewDetails;
@property (strong, nonatomic) IBOutlet UIImageView *dataItemImage;

//view's utilizadas no scroll
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) IBOutlet UIView *scrollContainer;
@property (strong, nonatomic) IBOutlet UIView *viewLoading;

@property (strong, nonatomic) IBOutlet UILabel *tLoadingMessage;



@end
