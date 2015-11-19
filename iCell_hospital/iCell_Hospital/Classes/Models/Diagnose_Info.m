//
//  Diagnose_Info.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_Info.h"

@implementation Diagnose_Info

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
    if ([key isEqualToString:@"title"]) {
        _tit = value;
    }

}

@end
