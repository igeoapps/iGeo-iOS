//
//  IGEOSearchButton.m
//  IGEOApp
//
//  Created by Bitcliq on 15/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOSearchButton.h"
#import "IGEOUtils.h"
#import "IGEOConfigsManager.h"

@implementation IGEOSearchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/**
 Personalização do efeito de clique.
 */
- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [IGEOUtils colorWithHexString:[[IGEOConfigsManager getAppConfigs] appColor] alpha:0.6f];
    }
    else {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
    }
}

@end
