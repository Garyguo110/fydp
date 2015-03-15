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
#import "SSGroup.h"
#import <UIKit/UIKit.h>

@interface SSManager : NSObject

@property (nonatomic, readonly) DataHelper *dataHelper;
@property (nonatomic, strong) NSArray *unclaimedIds;
@property (nonatomic, strong) NSMutableArray *unclaimedLights;
@property (nonatomic, strong) NSMutableArray *unclaimedSwitches;
@property (nonatomic, strong) NSMutableArray *groups;

+ (SSManager *) sharedInstance;
- (UIView *)findSuperViewOf:(UIView *)view WithClass:(Class)superViewClass;
- (SSCore *) getLightWithId:(NSString *)idString;
- (void) changeNameForCore:(SSCore *)core to:(NSString *)newName;
- (void) addCore:(SSCore *)core;
- (void) removeCore:(SSCore *)core fromGroup:(SSGroup *)group;
- (void) addCore:(SSCore *)core toGroup:(SSGroup *)group;
- (void) removeGroupAtIndex:(NSInteger *)index;
- (void) setUnclaimedIds:(NSArray *)ids;
- (void) saveData;
- (void) loadData;

@end
