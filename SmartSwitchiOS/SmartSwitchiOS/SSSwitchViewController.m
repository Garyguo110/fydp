//
//  SSSwitchViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/14/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSSwitchViewController.h"
#import "SSManager.h"
#import "SSGroup.h"
#import "SSCore.h"
#import "SSSwitchTableViewCell.h"
#import "SSEditDeviceViewController.h"
#import "SSAddDeviceViewController.h"
#import "SSAddGroupViewController.h"

@interface SSSwitchViewController ()

@end

@implementation SSSwitchViewController {
    SSGroup *selectedGroup;
    SSCore *selectedCore;
    NSIndexPath *indexToDelete;
    NSIndexPath *selectedIndex;
    BOOL isEdit;
    BOOL isGroupOn;
}
@synthesize spinnerView;

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
    
    isGroupOn = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTableView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editLightCore:) name:@"editLightCore" object:nil];
    
    spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [spinnerView setBackgroundColor:[UIColor grayColor]];
    [spinnerView setAlpha:0.5];
    [self.view addSubview:spinnerView];
    [spinnerView setHidden:YES];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadTableView:)
                  forControlEvents:UIControlEventValueChanged];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    NSLog(@"%@",[[SSManager sharedInstance] groups]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLight:(id)sender {
    selectedGroup = ((SSSwitchTableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[SSSwitchTableViewCell class]]).group;
    if (selectedGroup.lights.count > 0) {
        NSString *deviceId = [[selectedGroup.lights objectAtIndex:0] deviceId];
        [[SSManager sharedInstance].dataHelper getLightState:deviceId success:^(NSNumber *statusCode) {
            isGroupOn = statusCode.integerValue == 1;
            [self performSegueWithIdentifier:@"addLight" sender:sender];
        } failure:^(NSString *error) {
            NSLog(@"Error recieved: %@", error);
        }];
    } else {
        [self performSegueWithIdentifier:@"addLight" sender:sender];
    }
}

- (void)addDevice:(id)sender {
    [[SSManager sharedInstance].dataHelper getDevices:^(NSArray *ids) {
        [[SSManager sharedInstance] setUnclaimedIds:ids];
        [self performSegueWithIdentifier:@"addDevice" sender:sender];
    } failure:^(NSString *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)addGroup:(id)sender {
    isEdit = NO;
    [self performSegueWithIdentifier:@"addGroup" sender:sender];
}

- (void)editRow:(id)sender {
    isEdit = YES;
    selectedGroup = ((SSSwitchTableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[SSSwitchTableViewCell class]]).group;
    [self performSegueWithIdentifier:@"addGroup" sender:sender];
}

- (void)deleteRow:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete?" message:@"Deleting this row will also delete all associated mapping information" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    SSSwitchTableViewCell * cell =  (SSSwitchTableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[SSSwitchTableViewCell class]];
    indexToDelete = [self.tableView indexPathForCell:cell];
    [alert show];
}

- (void)reloadTableView:(id)sender {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)editLightCore:(NSNotification *)notification {
    selectedCore = [[notification userInfo] objectForKey:@"core"];
    [self performSegueWithIdentifier:@"editDevice" sender:notification];
}

#pragma mark - SSLightViewControllerDelegate

- (void)didCancelSelectLightFrom:(SSLightViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectLightFrom:(SSLightViewController *)controller withCore:(SSCore *)core {
    [spinnerView setHidden:NO];
    if (controller.isGroupOn && !core.isSwitch) {
        [[SSManager sharedInstance].dataHelper flipLight:core.deviceId withCommand:@"ON" success:^(NSNumber *statusCode) {
            NSLog(@"Status code %@ when flipping %@", statusCode, core.deviceId);
        } failure:^(NSString *error) {
            NSLog(error);
        }];
    } else if (!controller.isGroupOn && !core.isSwitch) {
        [[SSManager sharedInstance].dataHelper flipLight:core.deviceId withCommand:@"OFF" success:^(NSNumber *statusCode) {
            NSLog(@"Status code %@ when flipping %@", statusCode, core.deviceId);
        } failure:^(NSString *error) {
            NSLog(error);
        }];
    }
    [[SSManager sharedInstance].dataHelper setCore:core.deviceId forGroup:selectedGroup.groupId success:^(NSNumber *statusCode) {
        NSLog(@"Recieved status code of %@ when mapping %@ to %@", statusCode, core.name, selectedGroup.name);
        [[SSManager sharedInstance] addCore:core toGroup:selectedGroup];
        [spinnerView setHidden:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - Alert View Delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        SSGroup *groupToDelete = [[SSManager sharedInstance].groups objectAtIndex:indexToDelete.row];
        __block int switchCount = 0;
        for (SSCore *core in groupToDelete.switches) {
            [[SSManager sharedInstance].dataHelper setCore:core.deviceId forGroup:@"" success:^(NSNumber *statusCode) {
                switchCount++;
                if(switchCount == [groupToDelete.switches count]) {
                    
                    [[SSManager sharedInstance] removeGroupAtIndex:indexToDelete.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexToDelete] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            } failure:^(NSString *error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
        }
    }
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
    return [[SSManager sharedInstance].groups count];// + ([[SSManager sharedInstance] unclaimedLights].count > 0 ? 1 : 0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
    cell.isUnclaimedCell = NO;
    cell.lightTableView.allowsSelection = NO;
    cell.lightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.clipsToBounds = YES;
    if(indexPath.row == [[SSManager sharedInstance].groups count]) {
        cell.isUnclaimedCell = YES;
        [cell.nameLabel setText:@"Unclaimed Lights"];
        [cell.nameLabel setTextColor:[UIColor grayColor]];
        [cell.addLightButton setHidden:YES];
        [cell.editButton setHidden:YES];
        [cell.deleteButton setHidden:YES];
        NSInteger rowCount = [[SSManager sharedInstance].unclaimedLights count];
        cell.lightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 768, 44*(rowCount + 1))];
        cell.lightTableView.delegate = cell;
        cell.lightTableView.dataSource = cell;
        cell.lightTableView.allowsMultipleSelectionDuringEditing = NO;
        cell.lightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [cell addSubview:cell.lightTableView];
        [cell.lightTableView reloadData];
    } else {
        cell.group = [[SSManager sharedInstance].groups objectAtIndex:[indexPath row]];
        [cell.addLightButton addTarget:self action:@selector(addLight:) forControlEvents:UIControlEventTouchUpInside];
        //[cell.editButton addTarget:self action:@selector(editRow:) forControlEvents:UIControlEventTouchUpInside];
        //[cell.deleteButton addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
        [cell.nameLabel setText:cell.group.name];
        NSInteger rowCount = [cell.group.switches count] + [cell.group.lights count];
        //add extra row for sections
        rowCount = rowCount > 0 ? rowCount + 1 : rowCount;
        cell.lightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 768, 44*rowCount)];
        cell.lightTableView.delegate = cell;
        cell.lightTableView.dataSource = cell;
        cell.lightTableView.allowsMultipleSelectionDuringEditing = NO;
        cell.lightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [cell addSubview:cell.lightTableView];
        [cell.isOn addTarget:cell action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        if (cell.group.lights.count > 0) {
            [[SSManager sharedInstance].dataHelper getLightState:[[cell.group.lights objectAtIndex:0] deviceId] success:^(NSNumber *lightState) {
                if (lightState.integerValue == 1) {
                    [cell.isOn setOn:YES animated:YES];
                } else {
                    [cell.isOn setOn:NO animated:YES];
                }
            } failure:^(NSString *error) {
                NSLog(error);
            }];
        } else {
            [cell.isOn setOn:NO animated:YES];
        }
        
    
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
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath isEqual:selectedIndex]) {
        CGFloat baseHeight = 44.0f;
        if(indexPath.row == [[SSManager sharedInstance].groups count]) {
            return baseHeight + [[SSManager sharedInstance].unclaimedLights count] * baseHeight;
        } else {
            SSGroup *group = [[SSManager sharedInstance].groups objectAtIndex:indexPath.row];
            
            if([group.switches count] + [group.lights count] == 0) {
                return baseHeight;
            }
            
            else {
                return baseHeight + 40 + ([group.switches count] + [group.lights count]) * 30 + 1;
            }
        }
    } else {
        return 44.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedIndex = indexPath;
    
    [tableView beginUpdates];
    [tableView endUpdates];
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
    if([segue.identifier isEqualToString:@"addLight"]) {
        UINavigationController *navController = segue.destinationViewController;
        SSLightViewController *lightController = [navController viewControllers][0];
        lightController.isGroupOn = isGroupOn;
        lightController.delegate = self;
    }
    if([segue.identifier isEqualToString:@"editDevice"]) {
        SSEditDeviceViewController *edvc = segue.destinationViewController;
        edvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        edvc.core = selectedCore;
    }
    if([segue.identifier isEqualToString:@"addDevice"]) {
        SSAddDeviceViewController *advc = segue.destinationViewController;
        advc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    if ([segue.identifier isEqualToString:@"addGroup"]) {
        SSAddGroupViewController *agvc = segue.destinationViewController;
        agvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        if (isEdit) {
            agvc.group = selectedGroup;
        }
        isEdit = NO;
    }
}


@end
