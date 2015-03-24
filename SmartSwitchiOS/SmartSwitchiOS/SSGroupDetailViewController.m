//
//  SSGroupDetailViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/16/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSGroupDetailViewController.h"
#import "SSEditGroupViewController.h"
#import "SSLightViewController.h"
#import "SSCore.h"
#import "SSManager.h"

@interface SSGroupDetailViewController ()

@end

@implementation SSGroupDetailViewController {
    BOOL isAddLight;
}

@synthesize group;
@synthesize nameLabel;
@synthesize mappingTableView;
@synthesize isOn;
@synthesize editButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [isOn setOn:YES animated:NO];
    [self.mappingTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [isOn addTarget:self action:@selector(switchGroup:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setGroupValue:(SSGroup *)group {
    if (self.group != group) {
        self.group = group;
        [self refreshView];
    }
}

- (void)selectedGroup:(SSGroup *)group {
    [self setGroupValue:group];
    [self refreshView];
}

- (BOOL)isEditing {
    return self.navigationController.visibleViewController != self;
}

- (void)showDetails {
    while (self.navigationController.visibleViewController != self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)refreshView {
    nameLabel.text = group.name;
    [mappingTableView reloadData];
    [isOn setOn:group.isOn animated:YES];
}

- (void)addLight:(id)sender {
    isAddLight = YES;
    [self performSegueWithIdentifier:@"AddCore" sender:sender];
}

- (void)addSwitch:(id)sender {
    isAddLight = NO;
    [self performSegueWithIdentifier:@"AddCore" sender:sender];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshView];
}

- (void)editGroup:(id)sender {
    [self performSegueWithIdentifier:@"EditGroup" sender:sender];
}

- (void)switchGroup:(id)sender {
    __block int lightCount = 0;
    __block BOOL isGroupOn = isOn.isOn;
    for (SSCore *core in group.lights) {
        NSString *command = self.isOn.isOn ? @"ON" : @"OFF";
        [[SSManager sharedInstance].dataHelper flipLight:core.deviceId withCommand:command success:^(NSNumber *statusCode) {
            NSLog(@"Got status %@ when flipping light %@", statusCode, core.deviceId);
            lightCount++;
            if (group.lights.count == lightCount) {
                group.isOn = isGroupOn;
                [self.delegate groupSwitched:group];
            }
        } failure:^(NSString *error) {
            NSLog(error);
        }];
    }
}


#pragma mark LightViewControllerDelegate;

#pragma mark TableView Delgate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoreCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CoreCell"];
    }
    
    SSCore *core;
    if (indexPath.section == 0) {
        core = [group.switches objectAtIndex:indexPath.row];
    } else {
        core = [group.lights objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = core.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSLog(@"%@", group.switches);
        return [group.switches count];
    } else {
        return [group.lights count];
    }
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
    
//    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    [addButton setFrame:CGRectMake(550.0, 5.0, 30.0, 30.0)];
//    addButton.hidden = NO;
//    [addButton setBackgroundColor:[UIColor clearColor]];
//    
//    if(section == 0) {
//        [addButton addTarget:self action:@selector(addSwitch:) forControlEvents:UIControlEventTouchUpInside];
//    } else {
//        [addButton addTarget:self action:@selector(addLight:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    [cell addSubview:addButton];
    
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
    } else if ([segue.identifier isEqualToString:@"EditGroup"]) {
        SSEditGroupViewController *egvc = (SSEditGroupViewController *)segue.destinationViewController;
        egvc.tempName = group.name;
        for (SSCore *core in group.switches) {
            core.tempName = core.name;
        }
        for (SSCore *core in group.lights) {
            core.tempName = core.name;
        }
        egvc.tempSwitches = [NSMutableArray arrayWithArray:group.switches];
        egvc.tempLights = [NSMutableArray arrayWithArray:group.lights];
        egvc.group = group;
    }
}


@end
