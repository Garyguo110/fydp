//
//  SSGroupTableViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/16/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSGroupTableViewController.h"
#import "SSManager.h"
#import "SSGroup.h"
#import "SSAddGroupViewController.h"
#import "SSGroupTableViewCell.h"

@interface SSGroupTableViewController ()

@end

@implementation SSGroupTableViewController {
    NSIndexPath *indexToSelect;
    NSIndexPath *oldIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.groupTableView addSubview:refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTableView" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView:(UIRefreshControl *)sender {
    [self.groupTableView reloadData];
    [sender endRefreshing];
}

- (void)reloadTableView:(id)sender {
    [self.groupTableView reloadData];
}

#pragma mark group switched delegate
- (void)groupSwitched:(SSGroup *)group {
    group.isOn = !group.isOn;
    [self.groupTableView reloadData];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.delegate showDetails];
        [self.groupTableView selectRowAtIndexPath:indexToSelect animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:self.groupTableView didSelectRowAtIndexPath:indexToSelect];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[SSManager sharedInstance].groups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[SSGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
    }
    SSGroup *group = [[SSManager sharedInstance].groups objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.nameLabel.text = group.name;
    if(group.lights.count > 0) {
        [[SSManager sharedInstance].dataHelper getLightState:[group.lights objectAtIndex:0] success:^(NSNumber *state) {
            group.isOn = state.integerValue == 1;
            cell.onView.backgroundColor = group.isOn ? [UIColor colorWithRed:66.0f/255 green:211.0f/255 blue:80.0f/255 alpha:1.0f] : [UIColor colorWithWhite:0.8 alpha:1.0];
            [self.delegate selectedGroup:group];
        } failure:^(NSString *error) {
            NSLog(error);
        }];
    } else {
        cell.onView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate isEditing]) {
        indexToSelect = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:@"Are you sure you want to change groups? Switching groups will cancel all edits" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SSGroup *group = [[SSManager sharedInstance].groups objectAtIndex:indexPath.row];
    [self.delegate selectedGroup:group];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddGroup"]) {
        SSAddGroupViewController *agvc = segue.destinationViewController;
        agvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
}

@end