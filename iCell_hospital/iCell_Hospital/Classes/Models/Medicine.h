//
//  Medicine.h
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Medicine : NSObject
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *img;
@property (nonatomic,strong)NSString *keywords;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *descript; //试用状
@property (nonatomic,strong)NSString *message;//详细信息
@property (nonatomic,strong)NSString *tap; //效果
@property (nonatomic,strong)NSString *type; //类别
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,assign)int price;
@property (nonatomic,strong)NSString *code;
@property (nonatomic,assign)BOOL flag;
@end
