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
@property (nonatomic, strong) NSMutableArray *fakeIds;

+ (SSManager *) sharedInstance;
- (UIView *)findSuperViewOf:(UIView *)view WithClass:(Class)superViewClass;
- (SSCore *) getLightWithId:(NSString *)idString;
- (void) changeNameForCore:(SSCore *)core to:(NSString *)newName;

@end