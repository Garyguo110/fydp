//
//  SSSwitchTableViewCell.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/25/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSSwitchTableViewCell.h"
#import "SSManager.h"

@implementation SSSwitchTableViewCell

@synthesize group;
@synthesize addLightButton;
@synthesize lightTableView;
@synthesize isUnclaimedCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isUnclaimedCell) {
        return [[SSManager sharedInstance].unclaimedLights count];
    }
    if(section == 0) {
        return [group.switches count];
    } else {
        return [group.lights count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Switches";
    } else {
        return @"Lights";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"LightForSwitchCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LightForSwitchCell"];
    }
    SSCore *core;
    if(isUnclaimedCell) {
        NSString *lightId = [[SSManager sharedInstance].unclaimedLights objectAtIndex:indexPath.row];
        core = [[SSManager sharedInstance] getLightWithId:lightId];
    } else {
        if([indexPath section] == 0) {
            core = [group.switches objectAtIndex:[indexPath row]];
        } else {
            core = [group.lights objectAtIndex:[indexPath row]];
        }
        UIButton *deleteLightButton  = [[UIButton alloc] initWithFrame:CGRectMake(706, 10, 44, 30)];
        [deleteLightButton setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteLightButton setFont:[UIFont systemFontOfSize:15]];
        [deleteLightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deleteLightButton addTarget:self action:@selector(deleteLightRow:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:deleteLightButton];
    }
    cell.textLabel.text = core.name;
    UIButton *editLightButton = [[UIButton alloc] initWithFrame:CGRectMake(644, 10, 30, 30)];
    [editLightButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editLightButton addTarget:self action:@selector(editLightRow:) forControlEvents:UIControlEventTouchUpInside];
    [editLightButton setFont:[UIFont systemFontOfSize:15]];
    [editLightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [cell addSubview:editLightButton];
    return cell;
}

- (void)editLightRow:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[UITableViewCell class]];
    NSIndexPath *indexPath = [self.lightTableView indexPathForCell:cell];
    SSCore *coreToEdit;
    if (isUnclaimedCell) {
        coreToEdit = [[SSManager sharedInstance].unclaimedLights objectAtIndex:indexPath.row];
    } else if ([indexPath section] == 0) {
        coreToEdit = [group.switches objectAtIndex:[indexPath row]];
    } else {
        coreToEdit = [group.lights objectAtIndex:[indexPath row]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editLightCore" object:nil userInfo:@{@"core": coreToEdit}];
}

- (void)deleteLightRow:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[UITableViewCell class]];
    NSIndexPath *indexPath = [self.lightTableView indexPathForCell:cell];
    SSCore *core = indexPath.section == 0 ? [group.switches objectAtIndex:indexPath.row] : [group.lights objectAtIndex:indexPath.row];
    [[SSManager sharedInstance].dataHelper setCore:core.deviceId forGroup:@"" success:^(NSNumber *statusCode) {
        [[SSManager sharedInstance] removeCore:core fromGroup:group];
        [self.lightTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];
    } failure:^(NSString *error) {
        NSLog(error);
    }];
    
}

@end
