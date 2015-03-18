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

@interface SSGroupDetailViewController ()

@end

@implementation SSGroupDetailViewController {
    BOOL isAddLight;
}

@synthesize group;
@synthesize nameLabel;
@synthesize mappingTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)refreshView {
    nameLabel.text = group.name;
    [mappingTableView reloadData];
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


#pragma mark LightViewControllerDelegate;

#pragma mark TableView Delgate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoreCell"];
    
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
    }
}


@end
