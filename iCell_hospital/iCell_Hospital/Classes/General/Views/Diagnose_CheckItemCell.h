//
//  Diagnose_CheckItemCell.h
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diagnose_CheckItem.h"

typedef void(^setData)();

@interface Diagnose_CheckItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *table;

@property(nonatomic,strong)Diagnose_CheckItem *item;
//用来刷新数据
@property(nonatomic,strong) setData initData;

@end
