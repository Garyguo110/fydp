//
//  SSManager.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/9/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSManager.h"
#import "SSCore.h"

@implementation SSManager

@synthesize dataHelper;
@synthesize unclaimedIds;
@synthesize unclaimedLights;
@synthesize unclaimedSwitches;
@synthesize groups;
@synthesize lightIds;

+ (SSManager *)sharedInstance {
    static SSManager *sharedSSManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSSManager = [[self alloc] init];
    });
    
    return sharedSSManager;
}

- (UIView *)findSuperViewOf:(UIView *)view WithClass:(Class)superViewClass {
    UIView *superView = view.superview;
    UIView *foundSuperView = nil;
    
    while (nil != superView && nil == foundSuperView) {
        if ([superView isKindOfClass:superViewClass]) {
            foundSuperView = superView;
        } else {
            superView = superView.superview;
        }
    }
    return foundSuperView;
}

- (id)init {
    if(self == [super init]) {
        dataHelper = [[DataHelper allocWithZone:nil] initWithBaseURL:[NSURL URLWithString:@"https://api.spark.io"]];
        dataHelper.DEBUG_MODE = NO;
        unclaimedLights = [[NSMutableArray alloc] init];
        unclaimedSwitches = [[NSMutableArray alloc] init];
        unclaimedIds = [[NSMutableArray alloc] init];
        groups = [[NSMutableArray alloc] init];
        
        lightIds = [[NSArray alloc] initWithObjects:@"53ff6a066667574829572567",@"55ff74066678505506381367", nil];
    }
    return self;
}

- (void)addCore:(SSCore *)core {
    if(core.isSwitch) {
        [unclaimedSwitches addObject:core];
    } else {
        [unclaimedLights addObject:core];
    }
    [self saveData];
}

- (void)addCore:(SSCore *)core toGroup:(SSGroup *)group {
    if (core.isSwitch) {
        [unclaimedSwitches removeObject:core];
        [group.switches addObject:core];
    } else {
        [unclaimedLights removeObject:core];
        [group.lights addObject:core];
    }
    [self saveData];
}

- (void)removeCore:(SSCore *)core fromGroup:(SSGroup *)group {
    if (core.isSwitch) {
        [group.switches removeObject:core];
        [unclaimedSwitches addObject:core];
    } else {
        [group.lights removeObject:core];
        [unclaimedLights addObject:core];
    }
    [self saveData];
}

- (void)removeGroupAtIndex:(NSInteger *)index {
    SSGroup *group = [groups objectAtIndex:index];
    while ([group.switches count] > 0) {
        [self removeCore:[group.switches objectAtIndex:0] fromGroup:group];
    }
    while([group.lights count] > 0) {
        [self removeCore:[group.lights objectAtIndex:0] fromGroup:group];
    }
    [groups removeObjectAtIndex:index];
    [self saveData];
}

- (void)setUnclaimedIds:(NSArray *)ids {
    for (SSGroup *group in groups) {
        ids = [ids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", [group.switches valueForKeyPath:@"deviceId"]]];
        ids = [ids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", [group.lights valueForKeyPath:@"deviceId"]]];
    }
    ids = [ids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", [unclaimedSwitches valueForKeyPath:@"deviceId"]]];
    ids = [ids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", [unclaimedLights valueForKeyPath:@"deviceId"]]];
    unclaimedIds = ids;
}

- (void)saveData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![dataHelper DEBUG_MODE]) {
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:groups] forKey:@"groups"];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:unclaimedLights] forKey:@"unclaimedLights"];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:unclaimedSwitches] forKey:@"unclaimedSwitches"];
    } else {
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:groups] forKey:@"groups_DEBUG"];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:unclaimedLights] forKey:@"unclaimedLights_DEBUG"];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:unclaimedSwitches] forKey:@"unclaimedSwitches_DEBUG"];
    }
    [defaults synchronize];
}

- (void)loadData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *_groups;
    NSData *_unclaimedLights;
    NSData *_unclaimedSwitches;
    if (![dataHelper DEBUG_MODE]) {
        _groups = [defaults objectForKey:@"groups"];
        _unclaimedLights = [defaults objectForKey:@"unclaimedLights"];
        _unclaimedSwitches = [defaults objectForKey:@"unclaimedSwitches"];
    } else {
        _groups = [defaults objectForKey:@"groups_DEBUG"];
        _unclaimedLights = [defaults objectForKey:@"unclaimedLights_DEBUG"];
        _unclaimedSwitches = [defaults objectForKey:@"unclaimedSwitches_DEBUG"];
    }
    if ([NSKeyedUnarchiver unarchiveObjectWithData:_groups] != nil) {
        groups = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:_groups]];
    }
    if ([NSKeyedUnarchiver unarchiveObjectWithData:_unclaimedLights] != nil) {
        unclaimedLights = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:_unclaimedLights]];
    }
    if ([NSKeyedUnarchiver unarchiveObjectWithData:_unclaimedSwitches] != nil) {
        unclaimedSwitches = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:_unclaimedSwitches]];
    }
}
@end
