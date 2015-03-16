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
    //CALayer *bottomBorderName = [CALayer layer];
    //bottomBorderName.frame = CGRectMake(0.0f, self.nameField.frame.size.height - 1, self.nameField.frame.size.width, 1.0f);
    //bottomBorderName.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    //[self.nameField.layer addSublayer:bottomBorderName];
    
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
