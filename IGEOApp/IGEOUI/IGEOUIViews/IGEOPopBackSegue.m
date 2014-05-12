//
//  IGEOPopBackSegue.m
//  TNatureIOS
//
//  Created by Bitcliq on 29/11/13.
//
//

#import "IGEOPopBackSegue.h"

@implementation IGEOPopBackSegue

- (void) perform {
    
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    
    [srcViewController.navigationController pushViewController:destViewController animated:YES];
    
    NSMutableArray *VCs = [srcViewController.navigationController.viewControllers mutableCopy];
    [VCs removeObjectAtIndex:[VCs count] - 2];
    srcViewController.navigationController.viewControllers = VCs;
    
    
    srcViewController = nil;
    destViewController = nil;
    VCs = nil;
    
    
}


-(void)popViewControllerUnsync:(NSTimer *) t
{
    [((UIViewController *)self.sourceViewController).navigationController popViewControllerAnimated:NO];
}

@end
