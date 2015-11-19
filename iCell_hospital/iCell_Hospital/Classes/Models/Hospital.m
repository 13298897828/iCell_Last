//
//  Hospital.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Hospital.h"

@implementation Hospital

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self._id = value ;
        //        NSLog(@"id的值为:%@",value );
    }
}

@end
