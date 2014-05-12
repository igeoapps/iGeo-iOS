//
//  IGEODataItemTitleListCell.m
//  IGEOApp
//
//  Created by Bitcliq on 21/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import "IGEODataItemTitleListCell.h"

@implementation IGEODataItemTitleListCell

@synthesize tName = _tName;

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

@end
