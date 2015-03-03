//
//  SSManager.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/9/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataHelper.h"
#import "SSCore.h"
#import <UIKit/UIKit.h>

@interface SSManager : NSObject

@property (nonatomic, readonly) DataHelper *dataHelper;
@property (nonatomic, strong) NSMutableArray *switches;
@property (nonatomic, strong) NSMutableArray *lights;
@property (nonatomic, strong) NSMutableDictionary *mapping;
@property (nonatomic, strong) NSArray *unclaimedIds;
@property (nonatomic, strong) NSMutableArray *unclaimedLights;

+ (SSManager *) sharedInstance;
- (UIView *)findSuperViewOf:(UIView *)view WithClass:(Class)superViewClass;
- (SSCore *) getLightWithId:(NSString *)idString;
- (void) changeNameForCore:(SSCore *)core to:(NSString *)newName;
- (void) addCore:(SSCore *)core;
- (void) removeMappingFromSwitch:(NSString *)switchId withIndex:(NSInteger)index;
- (void) addMappingToSwitch:(NSString *)switchId fromLight:(NSString *)lightId;
- (void) setUnclaimedIds:(NSArray *)ids;

@end
