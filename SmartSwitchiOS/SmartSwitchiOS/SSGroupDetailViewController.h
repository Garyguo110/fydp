//
//  SSGroupDetailViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/16/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSGroupTableViewController.h"
#import "SSGroup.h"

@interface SSGroupDetailViewController : UIViewController <GroupSelectionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SSGroup *group;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITableView *mappingTableView;

- (IBAction)addLight:(id)sender;
- (IBAction)addSwitch:(id)sender;
- (IBAction)editGroup:(id)sender;
- (void)setGroupValue:(SSGroup *)group;

@end
