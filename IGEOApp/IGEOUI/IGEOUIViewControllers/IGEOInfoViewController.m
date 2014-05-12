//
//  IGEOInfoViewController.m
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOInfoViewController.h"
#import "IGEOMainViewController.h"
#import "IGEOConfigsManager.h"
#import "IGEOUtils.h"

@interface IGEOInfoViewController ()

@end

@implementation IGEOInfoViewController

@synthesize infoWebView = _infoWebView;
@synthesize bHome = _bHome;
@synthesize bConnect = _bConnect;
@synthesize fromHome = _fromHome;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self applyConfigs];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [_infoWebView.scrollView setBounces:NO];
    
    //o carregamento da webview é feito de forma asicrona para não bloquear o iniciar do ViewController
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.4f
                                                      target: self
                                                    selector: @selector(loadWebViewAsync:)
                                                    userInfo: nil
                                                     repeats: NO];
    
    timer = nil;
    
    //vamos usar o swipe para fazer back para a home
    if(_fromHome){
        UISwipeGestureRecognizer * recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myUpAction:)];
        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [self.view addGestureRecognizer:recognizerUp];
        
        recognizerUp = nil;
    }
    else {
        UISwipeGestureRecognizer * recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightAction:)];
        [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self.view addGestureRecognizer:recognizerRight];
        
        recognizerRight = nil;
    }
    
    [self.view bringSubviewToFront:_bHome];
    
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    self.view.backgroundColor = [IGEOUtils colorWithHexString:[IGEOConfigsManager getAppConfigs].appColor alpha:1.0f];
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"backHomeInfo"]){
        IGEOMainViewController *vc = (IGEOMainViewController *) segue.destinationViewController;
        [vc setSourcesExists:YES];
        
        vc = nil;
    }
}






#pragma mark - métodos do swipe

- (IBAction)backClicked:(id)sender {
    self.title = @"";
    self.navigationController.viewControllers = [NSArray arrayWithObjects:self, nil];
    [self performSegueWithIdentifier:@"backHomeInfo" sender:self];
}


#pragma mark - cliques nos botões

- (IBAction)bHomeClicked:(id)sender {
    if(_fromHome){
        self.title = @"";
        self.navigationController.viewControllers = [NSArray arrayWithObjects:self, nil];
        [self performSegueWithIdentifier:@"backHomeInfo" sender:self];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - ações asincronas
-(void) loadWebViewAsync:(NSTimer *) t
{
    _infoWebView.delegate = self;
    [_infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [IGEOUtils getStringForKey:@"INFO_DEFAULT_URL"]]]]];
    
}


#pragma mark - métodos do delegate da webview

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_infoWebView setHidden:YES];
}


#pragma mark - metodos do swipe

-(void) myUpAction:(UISwipeGestureRecognizer *) r
{
    [self performSegueWithIdentifier:@"backHomeInfo" sender:self];
    
}


-(void) myRightAction:(UISwipeGestureRecognizer *) r
{
    [self.navigationController popViewControllerAnimated:YES];
    
}




#pragma mark - aplicação das configs

/**
 Aqui vamos ler e aplicar as configurações para este ecrã do ConfigsManager
 */
-(void) applyConfigs
{
    //header
    [_topView setImage:[UIImage imageNamed:[IGEOConfigsManager getTopImage]]];
}


@end
