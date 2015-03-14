//
//  SSAddGroupViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/4/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSGroup.h"

@interface SSAddGroupViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) SSGroup *group;

-(IBAction)saveGroup:(id)sender;
-(IBAction)cancelGroup:(id)sender;

@end
