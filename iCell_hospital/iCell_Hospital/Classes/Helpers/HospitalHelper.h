//
//  HospitalHelper.h
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HospitalHelper : NSObject
@property(nonatomic,assign)MAMapPoint myPoint;

@property(nonatomic,strong)NSString *currentCityName;




+ (instancetype)sharedHospitalHelper;

- (void)requestHttpUrl: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg success:(void (^)(id data) )success;

@end
