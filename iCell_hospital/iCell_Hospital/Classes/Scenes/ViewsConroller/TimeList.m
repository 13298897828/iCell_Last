//
//  TimeList.m
//  Time
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "TimeList.h"


@interface TimeList ()

@end

@implementation TimeList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [TimeManager sharedTimeManager].timeArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    
    //取出userDefault中的数组
    NSArray *arr = [appDelegate.appDefault objectForKey:@"allTime"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
    NSDate *date = arr[indexPath.row];
    cell.textLabel.text = [[dateFormatter stringFromDate:date] lowercaseString];
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //删除数据
        [[TimeManager sharedTimeManager] deleteTime:indexPath];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        //获取通知数组
        NSArray *notifyArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        for (UILocalNotification *localNotifi in notifyArr) {
            NSDictionary *userInfo = localNotifi.userInfo;
            if (userInfo) {
                //根据cell的内容获取userInfo的值
                NSDate *date = [userInfo objectForKey:cell.textLabel.text];
                NSDateFormatter *form = [NSDateFormatter new];
                NSString *dateStr = [form stringFromDate:date];
                
                //获取cell
                NSDate *d = [TimeManager sharedTimeManager].timeArr[indexPath.row];
                NSString *dStr = [form stringFromDate:d];
                
                if ([dateStr isEqualToString:dStr]) {
                    //删除提示
                    [[UIApplication sharedApplication] cancelLocalNotification:localNotifi];
                }
            }

        }
    }
}



@end
