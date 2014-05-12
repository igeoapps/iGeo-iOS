//
//  IGEOSourceListCell.h
//  IGEOApp
//
//  Created by Bitcliq on 11/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Célula utilizada para incluir uma fonte na lista de fontes.
 */
@interface IGEOSourceListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tName;
@property (strong, nonatomic) IBOutlet UILabel *tSubtitle;

@end
