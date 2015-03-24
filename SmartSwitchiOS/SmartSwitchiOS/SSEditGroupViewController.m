//
//  SSEditGroupViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/16/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSEditGroupViewController.h"
#import "SSManager.h"
#import "SSLightViewController.h"

@interface SSEditGroupViewController ()

@end

@implementation SSEditGroupViewController {
    BOOL isAddLight;
    BOOL isDeleteGroup;
    NSIndexPath *indexToDelete;
    UIView *loadingView;
    UIActivityIndicatorView *spinner;
}

@synthesize group;
@synthesize tempLights;
@synthesize tempSwitches;
@synthesize tempName;
@synthesize editTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameField.text = tempName;
    self.nameField.delegate = self;
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
//    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                0,
//                                                                [[UIScreen mainScreen] bounds].size.width,
//                                                                [[UIScreen mainScreen] bounds].size.height)];
//    loadingView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
//    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    spinner.center = loadingView.center;
//    [loadingView addSubview:spinner];
//    [spinner startAnimating];
//    [self.navigationController.view addSubview:loadingView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.nameField.text = tempName;
    [self.editTableView reloadData];
}

- (void)addSwitch:(id)sender {
    isAddLight = NO;
    [self performSegueWithIdentifier:@"AddCore" sender:sender];
}

- (void)addLight:(id)sender {
    isAddLight = YES;
    [self performSegueWithIdentifier:@"AddCore" sender:sender];
}

- (void)deleteCore:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:UITableViewCell.class];
    indexToDelete = [self.editTableView indexPathForCell:cell];
    isDeleteGroup = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete?" message:@"Deleting this will remove it from this lighting group" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)cancelEdits:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveEdits:(id)sender {
    NSMutableArray *coresToAdd = [[NSMutableArray alloc] init];
    NSMutableArray *coresToDelete = [[NSMutableArray alloc] init];
    for (SSCore *core in group.switches) {
        if (![tempSwitches containsObject:core]) {
            [coresToDelete addObject:core];
        }
    }
    for (SSCore *core in group.lights) {
        if (![tempLights containsObject:core]) {
            [coresToDelete addObject:core];
        }
    }
    for (SSCore *core in tempLights) {
        core.name = core.tempName;
        if (![group.lights containsObject:core]) {
            [coresToAdd addObject:core];
        }
    }
    for (SSCore *core in tempSwitches) {
        core.name = core.tempName;
        if(![group.switches containsObject:core]) {
            [coresToAdd addObject:core];
        }
    }
    group.name = tempName;
    if (coresToAdd.count + coresToDelete.count > 0) {
        [self performSegueWithIdentifier:@"Saving" sender:nil];
        __block int addRemoveCount = 0;
        for (SSCore *core in coresToAdd) {
            [[SSManager sharedInstance].dataHelper setCore:core.deviceId forGroup:group.groupId success:^(NSNumber *statusCode) {
                addRemoveCount++;
                [[SSManager sharedInstance] addCore:core toGroup:group];
                if (addRemoveCount == coresToAdd.count + coresToDelete.count) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.navigationController popViewControllerAnimated:YES];

                    }];

                }
            } failure:^(NSString *error) {
                NSLog(error);
            }];
        }
        for (SSCore *core in coresToDelete) {
            [[SSManager sharedInstance].dataHelper setCore:core.deviceId forGroup:@"" success:^(NSNumber *statusCode) {
                addRemoveCount++;
                [[SSManager sharedInstance] removeCore:core fromGroup:group];
                if (addRemoveCount == coresToDelete.count + coresToAdd.count) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.navigationController popViewControllerAnimated:YES];

                    }];
                }
            } failure:^(NSString *error) {
                NSLog(error);
            }];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)deleteGroup:(id)sender {
    isDeleteGroup = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete?" message:@"Deleting this row will also delete all associated mapping information" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

#pragma mark UIAlertView delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (isDeleteGroup) {
            if (group.switches.count == 0) {
                [[SSManager sharedInstance] deleteGroup:group];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil userInfo:nil];
            } else {
                __block int deleteCount = 0;
                [self performSegueWithIdentifier:@"Saving" sender:nil];
                for (SSCore *core in group.switches) {
                    [[SSManager sharedInstance].dataHelper setCore:core.deviceId forGroup:@"" success:^(NSNumber *statusCode) {
                        deleteCount++;
                        if (deleteCount == group.switches.count) {
                            [self dismissViewControllerAnimated:YES completion:^{
                                [[SSManager sharedInstance] deleteGroup:group];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil userInfo:nil];
                            }];

                        }
                    } failure:^(NSString *error) {
                        NSLog(error);
                    }];
                }
            }
        } else {
            if (indexToDelete.section == 0) {
                [tempSwitches removeObjectAtIndex:indexToDelete.row];
            } else {
                [tempLights removeObjectAtIndex:indexToDelete.row];
            }
            [self.editTableView deleteRowsAtIndexPaths:@[indexToDelete] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.editTableView reloadData];
        }
        
    }
}

#pragma mark UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        UITableViewCell *cell = (UITableViewCell *)[[SSManager sharedInstance] findSuperViewOf:textField WithClass:UITableViewCell.class];
        
        NSIndexPath *ip = [self.editTableView indexPathForCell:cell];
        if (ip.section == 0) {
            [[tempSwitches objectAtIndex:ip.row] setTempName:textField.text];
        } else {
            [[tempLights objectAtIndex:ip.row] setTempName:textField.text];
        }
        [self.editTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.editTableView.frame = CGRectMake(self.editTableView.frame.origin.x, self.editTableView.frame.origin.y, self.editTableView.frame.size.width, self.editTableView.frame.size.height+270);
    } else if (textField.tag == 2) {
        tempName = textField.text;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name" message:@"Name can not be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        UITableViewCell *cell = (UITableViewCell *)[[SSManager sharedInstance] findSuperViewOf:textField WithClass:UITableViewCell.class];
        
        NSIndexPath *ip = [self.editTableView indexPathForCell:cell];
        
        self.editTableView.frame = CGRectMake(self.editTableView.frame.origin.x, self.editTableView.frame.origin.y, self.editTableView.frame.size.width, self.editTableView.frame.size.height-270);

        [self.editTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark UITableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return tempSwitches.count;
    } else {
        return tempLights.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoreCell"];
    
    UITextField *coreNameField = (UITextField *)[cell viewWithTag:1];
    if (indexPath.section == 0) {
        coreNameField.text = [[tempSwitches objectAtIndex:indexPath.row] tempName];
    } else {
        coreNameField.text = [[tempLights objectAtIndex:indexPath.row] tempName];
    }
    
    [coreNameField setDelegate:self];
    
    UIButton *deleteButton = (UIButton *)[cell viewWithTag:5];
    [deleteButton addTarget:self action:@selector(deleteCore:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Switches";
    } else {
        return @"Lights";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    
    UILabel *_nameLabel = (UILabel *)[cell viewWithTag:1];
    _nameLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setFrame:CGRectMake(550.0, 5.0, 30.0, 30.0)];
    addButton.hidden = NO;
    [addButton setBackgroundColor:[UIColor clearColor]];
    [addButton setBackgroundImage:[UIImage imageNamed:@"Plus-50 (1).png"] forState:UIControlStateNormal];
    
    if(section == 0) {
        [addButton addTarget:self action:@selector(addSwitch:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [addButton addTarget:self action:@selector(addLight:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell addSubview:addButton];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddCore"]) {
        SSLightViewController *lvc = segue.destinationViewController;
        lvc.group = self.group;
        lvc.isLights = isAddLight;
        if (isAddLight) {
            NSArray *availFromUnclaimed = [[SSManager sharedInstance].unclaimedLights filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", tempLights]];
            NSArray *availFromDeleted = [self.group.lights filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", tempLights]];
            lvc.availableCores = [availFromUnclaimed arrayByAddingObjectsFromArray:availFromDeleted];
        } else {
            NSArray *availFromUnclaimed = [[SSManager sharedInstance].unclaimedSwitches filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", tempSwitches]];
            NSArray *availFromDeleted = [self.group.switches filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", tempSwitches]];
            lvc.availableCores = [availFromUnclaimed arrayByAddingObjectsFromArray:availFromDeleted];

        }
        lvc.editController = self;
    }
    if ([segue.identifier isEqualToString:@"Saving"]) {
        UIViewController *vc = segue.destinationViewController;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
}


@end
