//
//  SSCore.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/14/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSCore.h"

@implementation SSCore

@synthesize isSwitch;
@synthesize deviceId;
@synthesize tempName;
@synthesize name;

-(id)init {
    self = [super init];
    if (self) {
        isSwitch = false;
        deviceId = @"";
        name = @"";
    }
    return self;
}

- (id)initWithName:(NSString *)name deviceId:(NSString *)deviceId switch:(BOOL)isSwitch {
    self = [super init];
    if(self) {
        self.isSwitch = isSwitch;
        self.deviceId = deviceId;
        self.name = name;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        name = [aDecoder decodeObjectForKey:@"name"];
        deviceId = [aDecoder decodeObjectForKey:@"deviceId"];
        isSwitch = [aDecoder decodeBoolForKey:@"isSwitch"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:deviceId forKey:@"deviceId"];
    [encoder encodeBool:isSwitch forKey:@"isSwitch"];
}

@end
