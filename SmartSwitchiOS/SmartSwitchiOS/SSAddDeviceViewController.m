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

#define ARCRANDOM_MAX 0x100000000

@interface SSAddDeviceViewController ()

@end

@implementation SSAddDeviceViewController {
    NSIndexPath  *selectedIndex;
}

@synthesize nameField;


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
    BOOL isSwitch;
    if([nameField.text isEqualToString:@""] || selectedIndex == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Insufficient Data" message:@"Please select a device id and provide a name for the device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    NSString *deviceId = [[SSManager sharedInstance].unclaimedIds objectAtIndex:selectedIndex.row];

    [[SSManager sharedInstance].dataHelper flipLight:deviceId withCommand:@"OFF" success:^(NSNumber *statusCode) {
        NSLog(@"got status code of %@ when flipping %@", statusCode, deviceId);
    } failure:^(NSString *error) {
        NSLog(error);
    }];
    
    if ([[SSManager sharedInstance].dataHelper DEBUG_MODE]) {
        double rand = ((double)arc4random() / ARCRANDOM_MAX);
        if(rand > 0.5) {
            isSwitch = YES;
        } else {
            isSwitch = NO;
        }
    } else {
        isSwitch = ![[SSManager sharedInstance].lightIds containsObject:deviceId];
    }
    SSCore *newCore = [[SSCore alloc] initWithName:nameField.text deviceId:[[SSManager sharedInstance].unclaimedIds objectAtIndex:selectedIndex.row] switch:isSwitch];
    [[SSManager sharedInstance] addCore:newCore];
    NSString *state = isSwitch ? @"SWITCH" : @"LIGHT";
    [[SSManager sharedInstance].dataHelper setState:state forDevice:newCore.deviceId success:^(NSNumber *status) {
        NSLog(@"Status %@ when setting state for %@", status, newCore.name);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)cancelAddDevice:(id)sender {
    if ([SSManager sharedInstance].unclaimedIds.count > 0) {
        NSString *deviceId = [[SSManager sharedInstance].unclaimedIds objectAtIndex:selectedIndex.row];
        [[SSManager sharedInstance].dataHelper flipLight:deviceId withCommand:@"OFF" success:^(NSNumber *statusCode) {
            NSLog(@"Got statuscode %@ when flipping %@", statusCode, deviceId);
        } failure:^(NSString *error) {
            NSLog(error);
        }];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    CALayer *topBorderSave = [CALayer layer];
    topBorderSave.frame = CGRectMake(0.0f, 0.0f, self.saveButton.frame.size.width, 1.0f);
    topBorderSave.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    [self.saveButton.layer addSublayer:topBorderSave];
    
    CALayer *topBorderCancel = [CALayer layer];
    topBorderCancel.frame = CGRectMake(0.0f, 0.0f, self.cancelButton.frame.size.width, 1.0f);
    topBorderCancel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    [self.cancelButton.layer addSublayer:topBorderCancel];
    
    CALayer *leftBorderSave = [CALayer layer];
    leftBorderSave.frame = CGRectMake(0.0f, 0.0f, 1.0f, self.saveButton.frame.size.height);
    leftBorderSave.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    [self.saveButton.layer addSublayer:leftBorderSave];
}

#pragma  mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[SSManager sharedInstance].unclaimedIds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceCell"];
    }
    cell.textLabel.text = [[SSManager sharedInstance].unclaimedIds objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *deviceId = [[SSManager sharedInstance].unclaimedIds objectAtIndex:selectedIndex.row];
    [[SSManager sharedInstance].dataHelper flipLight:deviceId withCommand:@"OFF" success:^(NSNumber *statusCode) {
        NSLog(@"got status code of %@ when flipping %@", statusCode, deviceId);
    } failure:^(NSString *error) {
        NSLog(error);
    }];
    selectedIndex = indexPath;
    deviceId = [[SSManager sharedInstance].unclaimedIds objectAtIndex:selectedIndex.row];
    [[SSManager sharedInstance].dataHelper flipLight:deviceId withCommand:@"ON" success:^(NSNumber *statusCode) {
        NSLog(@"got status code of %@ when flipping %@", statusCode, deviceId);
    } failure:^(NSString *error) {
        NSLog(error);
    }];
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
