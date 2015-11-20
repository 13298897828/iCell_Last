//
//  AFNetworkingManager.h
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/20.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
@interface AFNetworkingManager : AFHTTPSessionManager


+ (instancetype)sharedClient;
@end
