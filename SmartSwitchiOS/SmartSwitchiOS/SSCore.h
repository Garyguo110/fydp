//
//  SSCore.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/14/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSCore : NSObject

@property (nonatomic, assign) BOOL isSwitch;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *name;

- (id)initWithName:(NSString *)name deviceId:(NSString *)deviceId switch:(BOOL)isSwitch;

@end
