//
//  IGEOCategoriesListCell.h
//  IGEOApp
//
//  Created by Bitcliq on 16/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Célula utilizada para representar uma categoria na escolha de categorias.
 */
@interface IGEOCategoryListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *icon;

@end
