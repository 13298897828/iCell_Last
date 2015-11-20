//
//  AFNetworkingManager.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/20.
//  Copyright © 2015年 张天琦. All rights reserved.
//
#pragma mark - 网络状态
#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworkingManager.h"

@implementation AFNetworkingManager


static NSString * const AFAppDotNetAPIBaseURLString = @"https://api.app.net/";



+ (instancetype)sharedClient {
    static AFNetworkingManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
 
        _sharedClient = [[AFNetworkingManager alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWWAN------");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWiFi------");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"-------AFNetworkReachabilityStatusNotReachable------");
                    break;
                default:
                    break;
            }
        }];
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
    return _sharedClient;
}



@end
