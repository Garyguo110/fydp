//
//  SSLightViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/22/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCore.h"
#import "SSGroup.h";

@class SSLightViewController;

@protocol SSLightViewControllerDelegate <NSObject>
- (void)didSelectLightFrom:(SSLightViewController *)controller withCore:(SSCore *)core;
- (void)didCancelSelectLightFrom:(SSLightViewController *)controller;
@end;

@interface SSLightViewController : UITableViewController

@property (nonatomic, strong) SSGroup *group;
@property (nonatomic, assign) BOOL isGroupOn;
@property (nonatomic, assign) BOOL isLights;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
