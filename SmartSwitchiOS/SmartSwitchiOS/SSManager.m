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
@synthesize switches;
@synthesize lights;
@synthesize mapping;
@synthesize unclaimedIds;
@synthesize unclaimedLights;

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
        switches = [[NSMutableArray alloc] init];
        lights = [[NSMutableArray alloc] init];
        mapping = [[NSMutableDictionary alloc] init];
        unclaimedLights = [[NSMutableArray alloc] init];
        unclaimedIds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (SSCore *)getLightWithId:(NSString *)idString {
    return [lights filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"deviceId = %@",idString]][0];
}

- (void)changeNameForCore:(SSCore *)core to:(NSString *)newName {
    if (core.isSwitch) {
        for (int i = 0; i < switches.count; i++) {
            if ([((SSCore *)switches[i]).deviceId isEqualToString:core.deviceId]) {
                ((SSCore *)switches[i]).name = newName;
                break;
            }
        }
    } else {
        for (int i = 0; i < lights.count; i++) {
            if ([((SSCore *)lights[i]).deviceId isEqualToString:core.deviceId]) {
                ((SSCore *)lights[i]).name = newName;
                break;
            }
        }
    }
}

- (void)addCore:(SSCore *)core {
    if (core.isSwitch) {
        [switches addObject:core];
    } else {
        [lights addObject:core];
        [unclaimedLights addObject:core.deviceId];
    }
}

-(void)removeMappingFromSwitch:(NSString *)switchId withIndex:(NSInteger)index {
    NSString *removedId = [mapping objectForKey:switchId][index];
    [[mapping objectForKey:switchId] removeObjectAtIndex:index];
    for (NSString *key in mapping) {
        if ([[mapping objectForKey:key] containsObject:removedId]) {
            return;
        }
    }
    [unclaimedLights addObject:removedId];
}

- (void)addMappingToSwitch:(NSString *)switchId fromLight:(NSString *)lightId {
    if([mapping objectForKey:switchId] == nil) {
        [mapping setObject:[[NSMutableArray alloc] init] forKey:switchId];
    }
    [[mapping objectForKey:switchId] addObject:lightId];
    if([unclaimedLights containsObject:lightId]) {
        [unclaimedLights removeObject:lightId];
    }
}
- (void)setUnclaimedIds:(NSArray *)ids {
    NSArray *filterSwitches = [ids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", [switches valueForKeyPath:@"deviceId"]]];
    unclaimedIds = [filterSwitches filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF IN %@)", [lights valueForKeyPath:@"deviceId"]]];
}


@end
