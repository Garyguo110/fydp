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
- (BOOL)isEditing;
- (void)showDetails;

@end

@protocol GroupSwitchedDelegate <NSObject>;

@required
- (void)groupSwitched:(SSGroup *)group;

@end

@interface SSGroupTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, GroupSwitchedDelegate>

@property (nonatomic, assign) id<GroupSelectionDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView *groupTableView;

- (IBAction)refreshView:(UIRefreshControl *)sender;
- (IBAction)reloadTableView:(id)sender;

@end
