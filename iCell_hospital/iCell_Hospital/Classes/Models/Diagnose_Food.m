//
//  Diagnose_Food.m
//  iCell_Hospital
//
//  Created by 王颜华 on 15/11/14.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_Food.h"

@implementation Diagnose_Food

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
}

@end
