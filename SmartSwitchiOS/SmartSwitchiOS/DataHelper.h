//
//  DataHelper.h
//  SmartSwitchiOS
//
//  Created by Gary Guo on 2014-12-13.
//  Copyright (c) 2014 Guo. All rights reserved.
//
#import "AFHTTPClient.h"
#import <Foundation/Foundation.h>

#define kSPKWebClientAuthenticationError    @"SPKWebClientAuthenticationError"
#define kSPKWebClientConnectionError        @"SPKWebClientConnectionError"
#define kSPKWebClientReachabilityChange     @"kSPKWebClientReachabilityChange"
#define SPK_CLIENT_USERNAME @"spark"
#define SPK_CLIENT_PASSWORD @"kuybsvbeu67ibf4cb7o8a3rn2och8nm9fofjnlf987h87bsh43NWJ"

@interface DataHelper : AFHTTPClient

@property(nonatomic, strong)NSString *authToken;
@property(nonatomic, assign) BOOL DEBUG_MODE;

- (void)initDatahelper;
- (void)login:(void (^)(NSString *))authToken failure:(void (^)(NSString *))failure;
- (void)setState:(NSString *)state forDevice:(NSString *)deviceName success:(void (^)(NSNumber *))success failure:(void (^)(NSString *))failure;
- (void)flipLight:(void (^)(NSNumber *))success failure:(void (^)(NSString *))failure;
- (void)setCores:(void (^)(NSNumber *))success failure:(void (^)(NSString *))failure;
- (void) setCore:(NSString *)coreId forGroup:(NSString *)groupId success:(void (^)(NSNumber *))success failure:(void (^)(NSString *))failure;
- (void)getDevices:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure;

@end
