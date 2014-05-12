//
//  IGEOGenericSegue.m
//  IGEOApp
//
//  Created by Bitcliq, Lda on 04/05/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOGenericSegue.h"

@implementation IGEOGenericSegue

-(void)perform{
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    
    [srcViewController.navigationController pushViewController:destViewController animated:YES];
    
    srcViewController = nil;
    destViewController = nil;
}

@end
