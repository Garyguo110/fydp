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

@end

@implementation DataHelper

@synthesize authToken;

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
    [self login:nil failure:nil];
}

- (void)login:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    NSDictionary *params = @{
                             @"grant_type": @"password",
                             @"username": @"garyguo110@gmail.com",
                             @"password": @"Rasberryboat",
                             };
    
    [self setAuthorizationHeaderWithUsername:SPK_CLIENT_USERNAME password:SPK_CLIENT_PASSWORD];
    [self callMethod:@"POST" path:@"oauth/token" parameters:params notifyAuthenticationFailure:NO success:^(NSInteger statusCode, id JSON) {
        [self clearAuthorizationHeader];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:JSON
                                                             options:kNilOptions
                                                               error:&error];
        success(json[@"access_token"]);
    } failure:^(NSInteger statusCode, NSDictionary *dict) {
        failure([dict[@"errors"] componentsJoinedByString:@" "]);
    }];
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
