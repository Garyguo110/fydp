//
//  EditDeviceViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/27/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSEditDeviceViewController.h"
#import "SSManager.h"

@interface SSEditDeviceViewController ()

@end

@implementation SSEditDeviceViewController

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

-(void)saveEdit:(id)sender {
    if ([self.nameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Insufficient Data" message:@"A name must be provided for the device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self.core setName:self.nameField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelEdit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.nameField.text = self.core.name;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.nameField.frame.size.height - 1, self.nameField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    [self.nameField.layer addSublayer:bottomBorder];
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
