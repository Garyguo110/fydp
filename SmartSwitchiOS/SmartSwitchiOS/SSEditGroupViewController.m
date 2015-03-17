//
//  SSEditGroupViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/16/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSEditGroupViewController.h"

@interface SSEditGroupViewController ()

@end

@implementation SSEditGroupViewController {
    NSString *tempName;
    NSMutableArray *tempSwitches;
    NSMutableArray *tempLights;
}

@synthesize group;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.nameField.text = group.name;
    
    tempName = group.name;
    tempSwitches = [NSMutableArray arrayWithArray:group.switches];
    tempLights = [NSMutableArray arrayWithArray:group.lights];
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
        coreNameField.text = [[tempSwitches objectAtIndex:indexPath.row] name];
    } else {
        coreNameField.text = [[tempLights objectAtIndex:indexPath.row] name];
    }
    
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
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButton setFrame:CGRectMake(550.0, 5.0, 30.0, 30.0)];
    addButton.hidden = NO;
    [addButton setBackgroundColor:[UIColor clearColor]];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
