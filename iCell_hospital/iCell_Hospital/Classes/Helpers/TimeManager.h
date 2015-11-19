//
//  TimeManaher.h
//  Time
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 wx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject

@property(nonatomic,strong)NSDate *date;
@property(nonatomic,strong)NSMutableArray *timeArr;

+ (instancetype)sharedTimeManager;

- (NSString *)getCurrentTime;

//将时间提那家到时间数组中
- (void)addTime:(NSDate *)timeStr;

//删除设置的时间
- (void)deleteTime:(NSIndexPath *)indexPath;

@end
