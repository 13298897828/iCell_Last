//
//  HospitalHelper.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalHelper.h"

@implementation HospitalHelper

+ (instancetype)sharedHospitalHelper{
    static HospitalHelper *hospitalHP = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hospitalHP = [HospitalHelper new];
    });
    return hospitalHP;
}


-(void)requestHttpUrl: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg success:(void (^)(id data) )success{

    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"f72ae94aa12bc47efd2f17febaede0d3" forHTTPHeaderField: @"apikey"];


      NSURLSession *session = [NSURLSession sharedSession];

     NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

         if (error) {
             NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
         } else {
//             NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//             NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             success(data);
             
         }
     }];
        [dataTask resume];
}


/***
 * 此函数用来判断是否网络连接服务器正常
 * 需要导入Reachability类
 */
+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];  // 测试服务器状态
    
    switch([reachability currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = TRUE;
            break;
    }
    return  isExistenceNetwork;
}


@end
