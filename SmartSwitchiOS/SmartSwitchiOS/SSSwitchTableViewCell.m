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

@synthesize core;
@synthesize addLightButton;
@synthesize lightTableView;

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
    NSArray *cores = [[SSManager sharedInstance].mapping objectForKey:core.deviceId];
    return cores == nil ? 0 : [cores count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"LightForSwitchCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LightForSwitchCell"];
    }
    NSArray *pairedCores = [[SSManager sharedInstance].mapping objectForKey:core.deviceId];
    SSCore *light = [[SSManager sharedInstance] getLightWithId:[pairedCores objectAtIndex:indexPath.row]];
    cell.textLabel.text = light.name;
    UIButton *editLightButton = [[UIButton alloc] initWithFrame:CGRectMake(644, 10, 30, 30)];
    [editLightButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editLightButton addTarget:self action:@selector(editLightRow:) forControlEvents:UIControlEventTouchUpInside];
    [editLightButton setFont:[UIFont systemFontOfSize:15]];
    [editLightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *deleteLightButton  = [[UIButton alloc] initWithFrame:CGRectMake(706, 10, 44, 30)];
    [deleteLightButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteLightButton setFont:[UIFont systemFontOfSize:15]];
    [deleteLightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteLightButton addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:editLightButton];
    [cell addSubview:deleteLightButton];
    return cell;
}

- (void)editLightRow:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[UITableViewCell class]];
    NSIndexPath *indexPath = [self.lightTableView indexPathForCell:cell];
    SSCore *coreToEdit = [[[SSManager sharedInstance].mapping objectForKey:core.deviceId] objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editLightCore" object:nil userInfo:@{@"core": coreToEdit}];
}

- (void)deleteRow:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[SSManager sharedInstance] findSuperViewOf:sender WithClass:[UITableViewCell class]];
    NSIndexPath *indexPath = [self.lightTableView indexPathForCell:cell];
    [[[SSManager sharedInstance].mapping objectForKey:core.deviceId] removeObjectAtIndex:indexPath.row];
    [self.lightTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];
}

@end