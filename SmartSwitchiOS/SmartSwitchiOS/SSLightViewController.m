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

@implementation SSLightViewController

@synthesize idsToExclude;

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
    [self.delegate didCancelSelectLightFrom:self];
}

- (void)done:(id)sender {
    SSCoreTableViewCell *cell = (SSCoreTableViewCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    [self.delegate didSelectLightFrom:self withCore:cell.core];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"number of rows");
    NSLog(@"%d",[[SSManager sharedInstance].lights count]);
    return [[SSManager sharedInstance].lights filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(deviceId IN %@)",idsToExclude]].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSCoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LightCell" forIndexPath:indexPath];
    
    // Configure the cell...
    SSCore *light = [[[SSManager sharedInstance].lights filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(deviceId IN %@)",idsToExclude]] objectAtIndex:[indexPath row]];
    cell.core  = light;
    [cell.nameLabel setText:light.name];
    
    return cell;
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
