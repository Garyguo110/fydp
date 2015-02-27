//
//  SSCoreTableViewCell.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/23/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCore.h"

@interface SSCoreTableViewCell : UITableViewCell

@property (nonatomic, weak) SSCore *core;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end
