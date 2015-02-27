//
//  SSSwitchViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/14/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLightViewController.h"

@interface SSSwitchViewController : UITableViewController <SSLightViewControllerDelegate>

- (IBAction)addLight:(id)sender;
- (IBAction)addDevice:(id)sender;
- (IBAction)deleteRow:(id)sender;
- (IBAction)editRow:(id)sender;
- (IBAction)reloadTableView:(id)sender;
- (IBAction)editLightCore:(NSNotification *)notification;

@end
