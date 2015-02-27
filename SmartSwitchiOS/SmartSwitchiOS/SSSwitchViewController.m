//
//  SSSwitchViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/14/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSSwitchViewController.h"
#import "SSManager.h"
#import "SSCore.h"
#import "SSSwitchTableViewCell.h"
#import "SSLightsForSwitchViewController.h"
#import "SSEditDeviceViewController.h"

@interface SSSwitchViewController ()

@end

@implementation SSSwitchViewController {
    SSCore *selected;
}

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
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTableView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editLightCore:) name:@"editLightCore" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLight:(id)sender {
    selected = ((SSSwitchTableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[SSSwitchTableViewCell class]]).core;
    [self performSegueWithIdentifier:@"addLight" sender:sender];
}

- (void)addDevice:(id)sender {
    [self performSegueWithIdentifier:@"addDevice" sender:sender];
}

- (void)editRow:(id)sender {
    selected = ((SSSwitchTableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[SSSwitchTableViewCell class]]).core;
    [self performSegueWithIdentifier:@"editDevice" sender:sender];
}

- (void)deleteRow:(id)sender {
    SSSwitchTableViewCell * cell =  (SSSwitchTableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[SSSwitchTableViewCell class]];
    [[SSManager sharedInstance].mapping removeObjectForKey:cell.core.deviceId];
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    [[SSManager sharedInstance].switches removeObjectAtIndex:ip.row];
    [self.tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadTableView:(id)sender {
    [self.tableView reloadData];
}

- (void)editLightCore:(NSNotification *)notification {
    selected = (SSCore *)[[notification userInfo] objectForKey:@"core"];
    [self performSegueWithIdentifier:@"editDevice" sender:notification];
}

#pragma mark - SSLightViewControllerDelegate

- (void)didCancelSelectLightFrom:(SSLightViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectLightFrom:(SSLightViewController *)controller withCore:(SSCore *)core {
    SSCore *switchCore = selected;
    if([[SSManager sharedInstance].mapping objectForKey:switchCore.deviceId] == nil) {
        [[SSManager sharedInstance].mapping setObject:[[NSMutableArray alloc] init] forKey:switchCore.deviceId];
    }
    [[[SSManager sharedInstance].mapping objectForKey:switchCore.deviceId] addObject:core.deviceId];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
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
    return [[SSManager sharedInstance].switches count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
    cell.core = [[SSManager sharedInstance].switches objectAtIndex:[indexPath row]];
    [cell.addLightButton addTarget:self action:@selector(addLight:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editButton addTarget:self action:@selector(editRow:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
    [cell.nameLabel setText:cell.core.name];
    NSArray *pairedCores = [[SSManager sharedInstance].mapping objectForKey:cell.core.deviceId];
    NSInteger rowCount = pairedCores == nil ? 0 : pairedCores.count;
    cell.lightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 768, 44*rowCount)];
    cell.lightTableView.delegate = cell;
    cell.lightTableView.dataSource = cell;
    cell.lightTableView.allowsMultipleSelectionDuringEditing = NO;
    [cell addSubview:cell.lightTableView];

    
    //int i = 1;
    /*
    for (NSString *deviceId in [[SSManager sharedInstance].mapping objectForKey:cell.core.deviceId]) {
        SSCore *light = [[SSManager sharedInstance] getLightWithId:deviceId];
        UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [lightButton setFrame:CGRectMake(100, 44*i, 69, 30)];
        [lightButton setTitle:light.name forState:UIControlStateNormal];
        [lightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell addSubview:lightButton];
        i++;
    }
    */
    [cell.lightTableView reloadData];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat baseHeight = 44.0f;
    SSCore *switchCore = [[SSManager sharedInstance].switches objectAtIndex:indexPath.row];
    
    if ([[SSManager sharedInstance].mapping objectForKey:switchCore.deviceId] == nil) {
        return baseHeight;
    }
    
    return baseHeight + [[[SSManager sharedInstance].mapping objectForKey:switchCore.deviceId] count] * baseHeight;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SSSwitchTableViewCell *cell = (SSSwitchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [[SSManager sharedInstance].mapping removeObjectForKey:cell.core.deviceId];
        [[SSManager sharedInstance].switches removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
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


#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"switchDetail"]) {
        SSSwitchTableViewCell *cell = (SSSwitchTableViewCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        SSLightsForSwitchViewController *lfsController = segue.destinationViewController;
        lfsController.core = cell.core;
    }
    if([segue.identifier isEqualToString:@"addLight"]) {
        UINavigationController *navController = segue.destinationViewController;
        SSLightViewController *lightController = [navController viewControllers][0];
        lightController.delegate = self;
        NSArray *mappedIds = [[SSManager sharedInstance].mapping objectForKey:selected.deviceId];
        lightController.delegate = self;
        lightController.idsToExclude = mappedIds != nil ? mappedIds : [[NSArray alloc] initWithObjects:@"", nil];
    }
    if([segue.identifier isEqualToString:@"editDevice"]) {
        SSEditDeviceViewController *edvc = segue.destinationViewController;
        edvc.core = selected;
    }
}


@end
