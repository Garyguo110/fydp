//
//  SSEditGroupViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/16/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSGroup.h"

@interface SSEditGroupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITextField *nameField;

@property (nonatomic, strong) SSGroup *group;

@end
