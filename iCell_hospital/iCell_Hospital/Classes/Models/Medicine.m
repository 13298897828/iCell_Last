//
//  Medicine.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Medicine.h"

@implementation Medicine

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        _ID = value;
    }
    
    if ([key isEqualToString:@"description"]) {
        
        _descript = value;
    }
    
}

-(NSMutableArray *)messageArray{
    
    if (!_messageArray) {
        
        self.messageArray = [NSMutableArray new];
        
    }
    
    return _messageArray;
    
}


@end
