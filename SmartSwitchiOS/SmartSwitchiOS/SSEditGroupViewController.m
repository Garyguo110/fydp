//
//  SSEditGroupViewController.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/16/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSEditGroupViewController.h"
#import "SSManager.h"
#import "SSLightViewController.h"

@interface SSEditGroupViewController ()

@end

@implementation SSEditGroupViewController {
    BOOL isAddLight;
}

@synthesize group;
@synthesize tempLights;
@synthesize tempSwitches;
@synthesize tempName;
@synthesize editTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameField.text = tempName;
    self.nameField.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.nameField.text = tempName;
}

- (void)addSwitch:(id)sender {
    isAddLight = NO;
    [self performSegueWithIdentifier:@"AddCore" sender:sender];
}

- (void)addLight:(id)sender {
    isAddLight = YES;
    [self performSegueWithIdentifier:@"AddCore" sender:sender];
}

#pragma mark UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        UITableViewCell *cell = (UITableViewCell *)[[SSManager sharedInstance] findSuperViewOf:textField WithClass:UITableViewCell.class];
        
        NSIndexPath *ip = [self.editTableView indexPathForCell:cell];
        if (ip.section == 0) {
            [[tempSwitches objectAtIndex:ip.row] setTempName:textField.text];
        } else {
            [[tempLights objectAtIndex:ip.row] setTempName:textField.text];
        }
    } else if (textField.tag == 2) {
        tempName = textField.text;
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name" message:@"Name can not be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

#pragma mark UITableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return tempSwitches.count;
    } else {
        return tempLights.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoreCell"];
    
    UITextField *coreNameField = (UITextField *)[cell viewWithTag:1];
    if (indexPath.section == 0) {
        coreNameField.text = [[tempSwitches objectAtIndex:indexPath.row] tempName];
    } else {
        coreNameField.text = [[tempLights objectAtIndex:indexPath.row] tempName];
    }
    
    [coreNameField setDelegate:self];
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Switches";
    } else {
        return @"Lights";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    
    UILabel *_nameLabel = (UILabel *)[cell viewWithTag:1];
    _nameLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButton setFrame:CGRectMake(550.0, 5.0, 30.0, 30.0)];
    addButton.hidden = NO;
    [addButton setBackgroundColor:[UIColor clearColor]];
    
    if(section == 0) {
        [addButton addTarget:self action:@selector(addSwitch:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [addButton addTarget:self action:@selector(addLight:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell addSubview:addButton];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddCore"]) {
        SSLightViewController *lvc = segue.destinationViewController;
        lvc.group = self.group;
        lvc.isLights = isAddLight;
        lvc.editController = self;
    }
}


@end
