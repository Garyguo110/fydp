//
//  EditDeviceViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/27/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCore.h"

@interface SSEditDeviceViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) SSCore *core;

- (IBAction)saveEdit:(id)sender;
- (IBAction)cancelEdit:(id)sender;

@end
