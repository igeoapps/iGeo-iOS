//
//  IGEODataItemListCell.h
//  IGEOApp
//
//  Created by Bitcliq on 21/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Célula utilizada para representar uma categoria na lista de items.
 */
@interface IGEODataItemListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tName;
@property (strong, nonatomic) IBOutlet UILabel *tSubtitle;

@end
