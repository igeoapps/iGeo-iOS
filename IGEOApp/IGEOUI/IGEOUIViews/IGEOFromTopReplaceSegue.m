//
//  IGEOFromTopReplaceSegue.m
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

//http://jrwren.wrenfam.com/blog/2012/02/01/storyboard-custom-segue-for-custom-pushviewcontroller-animation/comment-page-1/

#import "IGEOFromTopReplaceSegue.h"

@implementation IGEOFromTopReplaceSegue

static const float HEIGHT = 480;

-(void)perform{
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    [dst viewWillAppear:NO];
    [dst viewDidAppear:NO];
    
    [src.view addSubview:dst.view];
    
    CGRect original = dst.view.frame;
    
    dst.view.frame = CGRectMake(dst.view.frame.origin.x, 0+dst.view.frame.size.height, dst.view.frame.size.width, HEIGHT);
    
    [UIView beginAnimations:nil context:nil];
    dst.view.frame = CGRectMake(original.origin.x, original.origin.y, original.size.height, original.size.width);
    [UIView commitAnimations];
    
    [self performSelector:@selector(animationDone:) withObject:dst afterDelay:0.2f];
}

/**
 Nesta e em outras segues vamos utilizar animações. Estas animações permitem personalizar o efeito de transição entre os viewcontrolers
 */
- (void)animationDone:(id)vc{
    UIViewController *dst = (UIViewController*)vc;
    UINavigationController *nav = [[self sourceViewController] navigationController];
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:dst animated:NO];
}

@end
