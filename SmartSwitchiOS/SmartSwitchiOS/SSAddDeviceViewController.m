//
//  SSAddDeviceViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/26/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSAddDeviceViewController.h"
#import "SSCore.h"
#import "SSManager.h"

@interface SSAddDeviceViewController ()

@end

@implementation SSAddDeviceViewController {
    NSInteger selectedIndex;
}

@synthesize nameField;
@synthesize idField;
@synthesize isSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addDevice:(id)sender {
    NSLog(@"%@",idField);
    NSLog(@"%@",idField.text);
    SSCore *newCore = [[SSCore alloc] initWithName:nameField.text deviceId:[[SSManager sharedInstance].fakeIds objectAtIndex:selectedIndex] switch:isSwitch.isOn];
    [[SSManager sharedInstance].fakeIds removeObjectAtIndex:selectedIndex];
    [[SSManager sharedInstance] addCore:newCore];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAddDevice:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[SSManager sharedInstance].fakeIds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceCell"];
    }
    cell.textLabel.text = [[SSManager sharedInstance].fakeIds objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = [indexPath row];
}

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
