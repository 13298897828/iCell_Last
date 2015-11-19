//
//  Diagnose_FoodCell.h
//  iCell_Hospital
//
//  Created by 王颜华 on 15/11/14.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diagnose_Food.h"

typedef void(^setData)();

@interface Diagnose_FoodCell : UITableViewCell

@property(nonatomic,strong)Diagnose_Food *food;
@property(nonatomic,strong) setData initData;

@end
