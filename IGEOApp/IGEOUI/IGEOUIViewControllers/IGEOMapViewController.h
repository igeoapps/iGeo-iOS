//
//  IGEOMapViewController.h
//  IGEOApp
//
//  Created by Bitcliq on 10/04/14.
//  Copyright (c) 2014 Bitcliq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IGEOConfigurableViewController.h"

@interface IGEOMapViewController : UIViewController<UIAlertViewDelegate, MKMapViewDelegate, IGEOConfigurable>

@property (strong, nonatomic) IBOutlet MKMapView *mMap;
@property (strong, nonatomic) IBOutlet UIButton *bback;
@property (strong, nonatomic) IBOutlet UIButton *bHome;
@property (strong, nonatomic) IBOutlet UIButton *bList;
@property (strong, nonatomic) IBOutlet UIButton *bMenu;
@property (nonatomic) BOOL fromExplore;
@property (nonatomic) BOOL fromList;
@property (strong, nonatomic) IBOutlet UILabel *tSubtitle;
@property (strong, nonatomic) IBOutlet UIView *viewLoading;
@property (strong, nonatomic) IBOutlet UIButton *bBackViewLoading;
@property (strong, nonatomic) IBOutlet UILabel *tLoadingMessage;


@property (strong, nonatomic) IBOutlet UIView *viewMenu;
@property (strong, nonatomic) IBOutlet UITableView *listViewMenu;


+(BOOL) getReloadData;
+(void) setReloadData:(BOOL) r;

@end
