//
//  SSMainViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/9/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSMainViewController.h"
#import "SSManager.h"

@interface SSMainViewController ()

@end

@implementation SSMainViewController

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
    [[SSManager sharedInstance].dataHelper setState:@"LIGHT" forDevice:@"55ff74066678505506381367" success:^
     (NSNumber *returnVal) {
         NSLog(@"State set for light: %d", returnVal.integerValue);
     } failure:^(NSString *failure) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:failure delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
    NSLog(@"Setting Switch");
    [[SSManager sharedInstance].dataHelper setState:@"SWITCH" forDevice:@"54ff6c066667515128301467" success:^(NSNumber *returnVal) {
        NSLog(@"State set for switch: %d", returnVal.integerValue);
    }failure:^(NSString *failure) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:failure delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    NSLog(@"Setting Cores");
    [[SSManager sharedInstance].dataHelper setCores:^
     (NSNumber *returnVal) {
         NSLog(@"Set Cores: %d", returnVal.integerValue);
     }failure:^(NSString *failure) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:failure delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchLight:(id)sender {

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
