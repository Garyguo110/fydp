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
        SSCore *switch1 = [[SSCore alloc] initWithName:@"Switch" deviceId:@"54ff6c066667515128301467" switch:YES];
        [[SSManager sharedInstance].switches addObject:switch1];
        NSLog(@"%@", [SSManager sharedInstance].switches);
        [self performSegueWithIdentifier:@"login" sender:sender];
    } failure:^(NSString * failure) {
        NSLog(failure);
    }];
}

@end
