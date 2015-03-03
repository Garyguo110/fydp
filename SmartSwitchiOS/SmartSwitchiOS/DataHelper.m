//
//  DataHelper.m
//  SmartSwitchiOS
//
//  Created by Gary Guo on 2014-12-13.
//  Copyright (c) 2014 Guo. All rights reserved.
//

#import "DataHelper.h"
#import "AFHTTPRequestOperation.h"

@interface DataHelper ()

@property (nonatomic, strong) dispatch_queue_t webQueue;
@property (nonatomic, strong) NSString *access_token;

@end

@implementation DataHelper {
}

@synthesize authToken;
@synthesize DEBUG_MODE;

//NSString *sparkAuthTokenURL = @"https://api.spark.io/oauth/token";
/*
static DataHelper *sharedObject = nil;

+ (DataHelper *)sharedInstance
{
    static dispatch_once_t _singletonPredicate;
    
    dispatch_once(&_singletonPredicate, ^{
        sharedObject = [[super allocWithZone:nil] init];
        [sharedObject initDatahelper];
    });
    
    return sharedObject;
}*/

- (void) initDatahelper {
}

- (void)login:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    if(DEBUG_MODE) {
        success(@"test");
    } else {
        NSDictionary *params = @{
                                 @"grant_type": @"password",
                                 @"username": @"jacob.simon01@gmail.com",
                                 @"password": @"rasberryboat",
                                 };
        
        [self setAuthorizationHeaderWithUsername:SPK_CLIENT_USERNAME password:SPK_CLIENT_PASSWORD];
        [self callMethod:@"POST" path:@"oauth/token" parameters:params notifyAuthenticationFailure:NO success:^(NSInteger statusCode, id JSON) {
            [self clearAuthorizationHeader];
            NSError* error;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:JSON
                                                                 options:kNilOptions
                                                                   error:&error];
            self.access_token = [json objectForKey:@"access_token"];
            NSLog(@"Saved Access Token");
            success([json objectForKey:@"access_token"]);
        } failure:^(NSInteger statusCode, NSDictionary *dict) {
            failure([dict[@"errors"] componentsJoinedByString:@" "]);
        }];
    }
}

- (void)setState:(NSString *)type forDevice:(NSString *)deviceName success:(void (^)(NSNumber *))success failure:(void (^)(NSString *))failure {
    if(DEBUG_MODE) {
        success([NSNumber numberWithInt:1]);
    } else {
        NSDictionary *params = @{
                                 @"access_token": self.access_token,
                                 @"params": type
                                 };
        [self callMethod:@"POST" path:[NSString stringWithFormat:@"/v1/devices/%@/setState", deviceName] parameters:params notifyAuthenticationFailure:NO success:^
         (NSInteger statusCode, id JSON) {
             NSError *error;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:JSON
                                                                  options:kNilOptions
                                                                    error:&error];
             success([json valueForKey:@"return_value"]);
         } failure:^(NSInteger statusCode, NSDictionary *dict) {
             failure([dict[@"errors"] componentsJoinedByString:@" "]);
         }];
    }
}

- (void)flipLight:(void (^)(NSNumber *))success failure:(void (^)(NSString *))failure {
    if(DEBUG_MODE) {
        success([NSNumber numberWithInt:1]);
    } else {
    NSDictionary *params = @{
                             @"access_token": self.access_token
                             };
    
    [self callMethod:@"POST" path:@"/v1/devices/54ff6d066672524816400167/flipLight" parameters:params notifyAuthenticationFailure:NO success:^
     (NSInteger statusCode, id JSON) {
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:JSON
                                                              options:kNilOptions
                                                                error:&error];
         success([json objectForKey:@"return_value"]);
     } failure:^(NSInteger statusCode, NSDictionary *dict) {
         failure([dict[@"errors"] componentsJoinedByString:@" "]);
     }];
    }
}

- (void)setCores:(void (^)(NSNumber *))success failure:(void (^)(NSString *))failure {
    if(DEBUG_MODE) {
        success([NSNumber numberWithInt:1]);
    } else {
        NSDictionary *params = @{
                                 @"access_token": self.access_token,
                                 @"params": @"55ff74066678505506381367"
                                 };
        
        [self callMethod:@"POST" path:@"v1/devices/54ff6c066667515128301467/setCores" parameters:params notifyAuthenticationFailure:NO success:^
         (NSInteger statusCode, id JSON) {
             NSError *error;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:JSON
                                                                  options:kNilOptions
                                                                    error:&error];
             success([json objectForKey:@"return_value"]);
         }failure:^(NSInteger statusCode, NSDictionary *dict) {
             failure([dict[@"errors"] componentsJoinedByString:@" "]);
         }];
    }
}

- (void)setLight:(NSString *)lightId forSwitch:(NSString *)switchId success:(void (^)(NSNumber *))success failure:(void (^)(NSString *))failure {
    if(DEBUG_MODE) {
        success([NSNumber numberWithInt:1]);
    } else {
        NSDictionary *params = @{
                                 @"access_token": self.access_token,
                                 @"params": lightId
                                 };
        
        [self callMethod:@"POST" path:[NSString stringWithFormat:@"v1/devices/%@/setCores", switchId] parameters:params notifyAuthenticationFailure:NO success:^
         (NSInteger statusCode, id JSON) {
             NSError *error;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:JSON
                                                                  options:kNilOptions
                                                                    error:&error];
             success([json objectForKey:@"return_value"]);
         }failure:^(NSInteger statusCode, NSDictionary *dict) {
             failure([dict[@"errors"] componentsJoinedByString:@" "]);
         }];
    }
}

- (void)getDevices:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    if(DEBUG_MODE) {
        success([NSArray arrayWithObjects:@"MC35751266MR",
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
                 @"MS3C851236MR", nil]);
    } else {
        NSDictionary *params = @{
                                 @"access_token": self.access_token
                                 };
        [self callMethod:@"GET" path:@"v1/devices" parameters:params notifyAuthenticationFailure:NO success:^
         (NSInteger statusCode, id JSON) {
             NSError *error;
             NSArray *json = [NSJSONSerialization JSONObjectWithData:JSON options:kNilOptions error:&error];
             NSMutableArray *ids = [json valueForKey:@"id"];
             NSLog(@"%@", ids);
             success(ids);
         }failure:^(NSInteger statusCode, NSDictionary *dict) {
             failure([dict[@"errors"] componentsJoinedByString:@" "]);
         }];
    }
}

- (void)callMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters notifyAuthenticationFailure:(BOOL)notifyAuthenticationFailure success:(void (^)(NSInteger, id))success failure:(void (^)(NSInteger, id))failure
{
    NSURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
    //    DDLogVerbose(@"%@ %@", request.URL, parameters);
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                                                          //                                                                          DDLogVerbose(@"%@ %@", operation, JSON);
                                                                          if ([operation.response statusCode] >= 200 && [operation.response statusCode] <= 299) {
                                                                              success([operation.response statusCode], JSON);
                                                                          } else if ([operation.response statusCode] == 400 && notifyAuthenticationFailure) {
                                                                              [[NSNotificationCenter defaultCenter] postNotificationName:kSPKWebClientAuthenticationError object:nil];
                                                                          } else {
                                                                              failure([operation.response statusCode], JSON);
                                                                          }
                                                                      }
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *e) {
                                                                          //                                                                          DDLogVerbose(@"%@ %@ %@ %@", operation, operation.response, [e localizedDescription], e);
                                                                          if ([operation.response statusCode] == 400) {
                                                                              if (notifyAuthenticationFailure) {
                                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:kSPKWebClientAuthenticationError object:nil];
                                                                              } else {
                                                                                  failure([operation.response statusCode], @{});
                                                                              }
                                                                          } else if ([operation.response statusCode] > 400 && [operation.response statusCode] <= 499) {
                                                                              
                                                                              failure([operation.response statusCode], @{});
                                                                          } else {
                                                                             
                                                                              [[NSNotificationCenter defaultCenter] postNotificationName:kSPKWebClientConnectionError object:self];
                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                  NSString *title;
                                                                                  NSString *msg;
                                                                                  if ([operation.response statusCode]) {
                                                                                      title = @"Internal error";
                                                                                      msg = @"An error was reported by the Spark Cloud. Please try again later. If the issue is not resolved, please visit www.spark.io/support for help.";
                                                                                  } else {
                                                                                      title = @"No connection";
                                                                                      msg = @"There was a problem communicating with Spark. Please check your internet connection.";
                                                                                  }
                                                                              });
                                                                          }
                                                                      }];
    operation.successCallbackQueue = self.webQueue;
    operation.failureCallbackQueue = self.webQueue;
    [self enqueueHTTPRequestOperation:operation];
}

@end
