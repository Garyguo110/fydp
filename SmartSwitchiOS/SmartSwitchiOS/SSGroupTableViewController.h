//
//  SSGroupTableViewController.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/16/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSGroup;
@protocol GroupSelectionDelegate <NSObject>;

@required
- (void)selectedGroup:(SSGroup *)group;

@end

@interface SSGroupTableViewController : UITableViewController

@property (nonatomic, assign) id<GroupSelectionDelegate> delegate;

@end
