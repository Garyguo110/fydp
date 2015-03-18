//
//  SSEditGroupViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/16/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSGroup.h"

@interface SSEditGroupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITableView *editTableView;

@property (nonatomic, strong) SSGroup *group;
@property (nonatomic, strong) NSMutableArray *tempLights;
@property (nonatomic, strong) NSMutableArray *tempSwitches;
@property (nonatomic, strong) NSString *tempName;

- (IBAction)addLight:(id)sender;
- (IBAction)addSwitch:(id)sender;

@end
