//
//  SSAddDeviceViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/26/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSAddDeviceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *idField;
@property (nonatomic, weak) IBOutlet UISwitch *isSwitch;

- (IBAction)addDevice:(id)sender;
- (IBAction)cancelAddDevice:(id)sender;

@end
