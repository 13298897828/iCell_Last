//
//  Diagnose_Operation.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_Operation.h"

@implementation Diagnose_Operation

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
}

@end
