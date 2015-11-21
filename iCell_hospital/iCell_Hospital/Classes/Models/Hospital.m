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

//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.name forKey:@"nameKey"];
//    
//    
//}
//
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self == [super init]) {
//        self.name = [aDecoder decodeObjectForKey:@"nameKey"];
//    }
//    return self;
//}
//
//- (id)copyWithZone:(NSZone *)zone{
//    Hospital *copy = [[[self class] allocWithZone:zone] init];
//    copy.name = [self.name copyWithZone:zone];
//    
//    
//    return copy;
//}

@end
