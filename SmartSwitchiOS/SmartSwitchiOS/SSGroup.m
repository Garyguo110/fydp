//
//  SSGroup.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/3/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSGroup.h"

@implementation SSGroup

@synthesize name;
@synthesize switches;
@synthesize lights;
@synthesize groupId;
@synthesize isOn;

-(id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.switches = [[NSMutableArray alloc] init];
        self.lights = [[NSMutableArray alloc] init];
        self.groupId = [SSGroup generateRandomString:20];
        isOn = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        switches = [decoder decodeObjectForKey:@"switches"];
        lights = [decoder decodeObjectForKey:@"lights"];
        name = [decoder decodeObjectForKey:@"name"];
        groupId = [decoder decodeObjectForKey:@"groupId"];
    }
    return self;
}

+ (NSString *)generateRandomString:(int)length {
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0U; i < length; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:switches forKey:@"switches"];
    [encoder encodeObject:lights forKey:@"lights"];
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:groupId forKey:@"groupId"];
}

@end
