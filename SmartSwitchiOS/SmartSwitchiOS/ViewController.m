//
//  ViewController.m
//  SmartSwitchiOS
//
//  Created by Gary Guo on 2014-12-13.
//  Copyright (c) 2014 Guo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DataHelper *d = [[DataHelper allocWithZone:nil] initWithBaseURL:[NSURL URLWithString:@"https://api.spark.io"]];
    [d initDatahelper];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
