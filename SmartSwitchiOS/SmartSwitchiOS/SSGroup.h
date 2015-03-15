//
//  SSGroup.h
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/3/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSGroup : NSObject <NSCoding>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSMutableArray* switches;
@property (nonatomic, strong) NSMutableArray *lights;

-(id)initWithName:(NSString *)name;

@end
