//
//  SSGroup.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/3/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSGroup : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray* switches;
@property (nonatomic, strong) NSArray *lights;
@end
