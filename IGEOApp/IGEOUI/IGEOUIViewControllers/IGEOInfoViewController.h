//
//  IGEOInfoViewController.h
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGEOConfigurableViewController.h"

/**
 ViewController que contém uma webview para acesso a página com informações do projecto.
 */
@interface IGEOInfoViewController : UIViewController<IGEOConfigurable, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *infoWebView;
@property (strong, nonatomic) IBOutlet UIButton *bHome;
@property (strong, nonatomic) IBOutlet UIButton *bConnect;

@property (nonatomic) BOOL fromHome;

@property (strong, nonatomic) IBOutlet UIImageView *topView;

@end
