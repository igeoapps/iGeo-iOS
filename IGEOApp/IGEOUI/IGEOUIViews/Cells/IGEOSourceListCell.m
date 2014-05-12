//
//  IGEOSourceListCell.m
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEOSourceListCell.h"

@implementation IGEOSourceListCell

@synthesize tName = _tName;
@synthesize tSubtitle = _tSubtitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}








- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
//    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(-10, self.bounds.size.height-1, 320+10, 1)];
//    bottomLineView.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
//    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
//    //backView.backgroundColor = [UIColor clearColor];
//    
//    if(highlighted) {
//        self.backgroundView.backgroundColor = [UIColor colorWithRed:123.0f/255 green:191.0f/255 blue:224.0f/255 alpha:0.6f];
//    } else {
//        backView.backgroundColor = [UIColor whiteColor];
//    }
//    
//    [self setBackgroundColor:[UIColor colorWithRed:123.0f/255 green:191.0f/255 blue:224.0f/255 alpha:0.6f]];
//    
//    self.backgroundView = backView;
//    
//    //[super setHighlighted:highlighted animated:animated];
//    
//    bottomLineView = nil;
//    backView = nil;
    
}

@end
