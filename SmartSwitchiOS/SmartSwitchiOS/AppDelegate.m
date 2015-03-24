//
//  AppDelegate.m
//  SmartSwitchiOS
//
//  Created by Gary Guo on 2014-12-13.
//  Copyright (c) 2014 Guo. All rights reserved.
//

#import "AppDelegate.h"
#import "SSManager.h"
#import "SSGroupTableViewController.h"
#import "SSGroupDetailViewController.h"
#import "SSManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[SSManager sharedInstance] loadData];
    UISplitViewController *svc = (UISplitViewController *)self.window.rootViewController;
    SSGroupTableViewController *gtvc = (SSGroupTableViewController *)[svc.viewControllers objectAtIndex:0];
    UINavigationController *rightNavController = [svc.viewControllers objectAtIndex:1];
    SSGroupDetailViewController *gdvc = (SSGroupDetailViewController *)[rightNavController topViewController];
    
    gtvc.delegate = gdvc;
    gdvc.delegate = gtvc;
    if ([SSManager sharedInstance].groups.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [gtvc.groupTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
    [[SSManager sharedInstance].dataHelper login:^(NSString *token) {
        [[SSManager sharedInstance].dataHelper getDevices:^(NSArray *ids) {
            [[SSManager sharedInstance] setUnclaimedIds:ids];
        } failure:^(NSString *error) {
            NSLog(error);
        }];
        
    } failure:^(NSString *error) {
        NSLog(error);
    }];
    
    if ([[SSManager sharedInstance] groups].count > 0) {
        [gdvc setGroupValue:[[SSManager sharedInstance].groups objectAtIndex:0]];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[SSManager sharedInstance] saveData];
}

@end
