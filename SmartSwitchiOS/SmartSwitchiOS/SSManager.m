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
@synthesize fakeIds;

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
        switches = [[NSMutableArray alloc] init];
        lights = [[NSMutableArray alloc] init];
        mapping = [[NSMutableDictionary alloc] init];
        fakeIds = [[NSMutableArray alloc] initWithObjects:@"MC35751266MR",
                 @"MC33351266MR",
                 @"MC3DE51266ML",
                 @"MC46751266ML",
                 @"MC08E51276MR",
                 @"MC11651276MR",
                 @"MC1EA51276MR",
                 @"MC11A51276MR",
                 @"MC3C151276ML",
                 @"MC38A51276MR",
                 @"MC44251276MR",
                 @"MS1B851236MR",
                 @"MN55B51236ML",
                 @"MN55A51236MR",
                 @"MC08451236MR",
                 @"MC4B351236ML",
                 @"MN59A51236MR",
                 @"MS10851236MR",
                 @"MN12551266MR",
                 @"MS39E51266ML",
                 @"MC07551246MR",
                 @"MS3C851236MR", nil];
        SSCore *light = [[SSCore alloc] initWithName:@"Light1" deviceId:@"55ff74066678505506381367" switch:NO];
        [lights addObject:light];
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
@end
