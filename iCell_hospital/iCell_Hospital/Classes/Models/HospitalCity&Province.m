//
//  HospitalCity&Province.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalCity&Province.h"

@implementation HospitalCity_Province

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self._id = value ;
    }
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"province===%@", self.province];
}

@end
