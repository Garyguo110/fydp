//
//  SSSwitchTableViewCell.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/25/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCore.h"

@interface SSSwitchTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) SSCore *core;
@property (nonatomic, weak) IBOutlet UIButton *addLightButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITableView *lightTableView;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

@end
