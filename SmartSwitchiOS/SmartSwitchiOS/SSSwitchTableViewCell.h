//
//  SSSwitchTableViewCell.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/25/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSGroup.h"

@interface SSSwitchTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) SSGroup *group;
@property (nonatomic, weak) IBOutlet UIButton *addLightButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) IBOutlet UITableView *lightTableView;
@property (nonatomic, assign) BOOL isUnclaimedCell;
@property (nonatomic, strong) IBOutlet UISwitch *isOn;

- (IBAction)editLightRow:(id)sender;
- (IBAction)deleteLightRow:(id)sender;
- (IBAction)switchChanged:(id)sender;

@end
