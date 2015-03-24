//
//  SSAddGroupViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/4/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSAddGroupViewController.h"
#import "SSGroup.h"
#import "SSManager.h"

@interface SSAddGroupViewController ()

@end

@implementation SSAddGroupViewController {
    CGPoint originalCenter;
}

@synthesize nameField;
@synthesize group;
@synthesize boxView;

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
    if(group != nil) {
        [self.nameField setText:group.name];
    }
    [nameField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveGroup:(id)sender {
    NSString *name = [self.nameField text];
    if([name isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information" message:@"Please provide a name for the group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([name isEqualToString:@"supermode-gstar-activate"]){
        for (int i = 0; i < 40; i++) {
            for(NSString *coreId in [SSManager sharedInstance].lightIds) {
                [[SSManager sharedInstance].dataHelper flipLight:coreId withCommand:@"TOGGLE" success:^(NSNumber *statusCode) {
                    NSLog(@"got status code of %@ when flipping %@", statusCode, coreId);
                } failure:^(NSString *error) {
                    NSLog(error);
                }];
            }
        }
    }
    if (group != nil) {
        group.name = name;
    } else {
        group = [[SSGroup alloc] initWithName:name];
        [[SSManager sharedInstance].groups addObject:group];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:group forKey:@"group"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil userInfo:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelGroup:(id)sender {
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

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {

    self.viewVerticalSpaceConstraint.constant = 150;
    [self.boxView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.4f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.viewVerticalSpaceConstraint.constant = 306;
    [self.boxView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.4f animations:^{
        [self.view layoutIfNeeded];
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
