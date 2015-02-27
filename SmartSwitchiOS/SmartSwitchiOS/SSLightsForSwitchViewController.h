//
//  SSLightViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/19/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLightViewController.h"
#import "SSCore.h"

@interface SSLightsForSwitchViewController : UITableViewController <SSLightViewControllerDelegate>

@property (nonatomic, weak) SSCore *core;

- (IBAction)addLight:(id)sender;
- (IBAction)addDevice:(id)sender;

@end
