//
//  DiagnoseManager.h
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Result)();

@interface DiagnoseManager : NSObject

//疾病资讯
@property(nonatomic,strong)NSArray *infoArr;
//检查项目
@property(nonatomic,strong)NSArray *itemArr;
//手术项目
@property(nonatomic,strong)NSArray *operateArr;


//定义一个回调函数
@property(nonatomic,copy)Result digResult;
@property(nonatomic,copy)Result digResult1;
@property(nonatomic,copy)Result digResult2;
@property(nonatomic,copy)Result digResult3;

//创建单例
+ (instancetype)sharedDiagnoseManager;

@end
