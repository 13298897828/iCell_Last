//
//  TimeManaher.m
//  Time
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "TimeManager.h"
#import <UIKit/UIKit.h>

@implementation TimeManager

+ (instancetype)sharedTimeManager{
    static TimeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [TimeManager new];
    });
    
    return manager;
}

//将时间添加到时间数组中
- (void)addTime:(NSDate *)timeStr{
    [self.timeArr addObject:timeStr];
}

//删除设置的时间
- (void)deleteTime:(NSIndexPath *)indexPath{
    [_timeArr removeObject:_timeArr[indexPath.row]];
}


//懒加载
- (NSMutableArray *)timeArr{
    if (!_timeArr) {
        self.timeArr = [NSMutableArray array];
    }
    return _timeArr;
}

@end
