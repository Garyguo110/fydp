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
        dataHelper.DEBUG_MODE = YES;
        unclaimedLights = [[NSMutableArray alloc] init];
        unclaimedSwitches = [[NSMutableArray alloc] init];
        unclaimedIds = [[NSMutableArray alloc] init];
        groups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addCore:(SSCore *)core {
    if(core.isSwitch) {
        [unclaimedSwitches addObject:core];
    } else {
        [unclaimedLights addObject:core];
    }
}

- (void)addCore:(SSCore *)core toGroup:(SSGroup *)group {
    if (core.isSwitch) {
        [unclaimedSwitches removeObject:core];
        [group.switches addObject:core];
    } else {
        [unclaimedLights removeObject:core];
        [group.lights addObject:core];
    }
}

- (void)removeCore:(SSCore *)core fromGroup:(SSGroup *)group {
    if (core.isSwitch) {
        [group.switches removeObject:core];
        [unclaimedSwitches addObject:core];
    } else {
        [group.lights removeObject:core];
        [unclaimedLights addObject:core];
    }
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


@end
