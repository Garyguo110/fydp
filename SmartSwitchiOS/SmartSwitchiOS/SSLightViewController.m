//
//  SSLightViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/22/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSLightViewController.h"
#import "SSManager.h"
#import "SSCore.h"
#import "SSCoreTableViewCell.h"

@interface SSLightViewController ()

@end

@implementation SSLightViewController {
    NSIndexPath *selectedIndex;
}

@synthesize isGroupOn;
@synthesize group;
@synthesize isLights;
@synthesize editController;
@synthesize availableCores;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel:(id)sender {
    NSString *deviceId = [[availableCores objectAtIndex:selectedIndex.row] deviceId];
    [[SSManager sharedInstance].dataHelper flipLight:deviceId withCommand:@"OFF" success:^(NSNumber *statusCode) {
        NSLog(@"got status code of %@ when flipping %@", statusCode, deviceId);
    } failure:^(NSString *error) {
        NSLog(error);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done:(id)sender {
    SSCoreTableViewCell *cell = (SSCoreTableViewCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    if (cell == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select a Core" message:@"You must select a core to continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *deviceId = [[availableCores objectAtIndex:selectedIndex.row] deviceId];
    [[SSManager sharedInstance].dataHelper flipLight:deviceId withCommand:@"OFF" success:^(NSNumber *statusCode) {
        NSLog(@"got status code of %@ when flipping %@", statusCode, deviceId);
    } failure:^(NSString *error) {
        NSLog(error);
    }];
    cell.core.tempName = cell.core.name;
    if ([cell.core isSwitch]) {
        [editController.tempSwitches addObject:cell.core];
    } else {
        [editController.tempLights addObject:cell.core];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return availableCores.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSCoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LightCell" forIndexPath:indexPath];
    
    // Configure the cell...
    SSCore *core = [availableCores objectAtIndex:indexPath.row];
    cell.core  = core;
    [cell.nameLabel setText:core.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *deviceId;
    if (selectedIndex != nil) {
        deviceId = [[availableCores objectAtIndex:selectedIndex.row] deviceId];
        [[SSManager sharedInstance].dataHelper flipLight:deviceId withCommand:@"OFF" success:^(NSNumber *statusCode) {
            NSLog(@"got status code of %@ when flipping %@", statusCode, deviceId);
        } failure:^(NSString *error) {
            NSLog(error);
        }];
    }
    selectedIndex = indexPath;
    deviceId = [[availableCores objectAtIndex:selectedIndex.row] deviceId];
    [[SSManager sharedInstance].dataHelper flipLight:deviceId withCommand:@"ON" success:^(NSNumber *statusCode) {
        NSLog(@"got status code of %@ when flipping %@", statusCode, deviceId);
    } failure:^(NSString *error) {
        NSLog(error);
    }];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
