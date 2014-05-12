//
//  IGEOConfigurableViewController.h
//  IGEOApp
//
//  Created by Bitcliq on 21/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Este protocolo é implementado em todos os ViewControllers desta App e define um método a implementar
 que é utilizado na obtenção das configurações do DataManager e da sua aplicação nas view's respetivas.
 */
@protocol IGEOConfigurable <NSObject>

@optional
-(void) applyConfigs;

@end

@interface IGEOConfigurableViewController : UIViewController

@end
