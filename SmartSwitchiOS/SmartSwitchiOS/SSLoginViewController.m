//
//  ViewController.m
//  SmartSwitchiOS
//
//  Created by Gary Guo on 2014-12-13.
//  Copyright (c) 2014 Guo. All rights reserved.
//

#import "SSLoginViewController.h"
#import "SSManager.h"
#import "SSCore.h"

@interface SSLoginViewController ()

@end

@implementation SSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Finished initializing data helper");
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)login:(id)sender {
    [[SSManager sharedInstance].dataHelper login:^(NSString * authToken) {
        [self performSegueWithIdentifier:@"login" sender:sender];
    } failure:^(NSString * failure) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:failure delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

@end
