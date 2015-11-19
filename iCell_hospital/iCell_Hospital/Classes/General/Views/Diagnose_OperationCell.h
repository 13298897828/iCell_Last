//
//  Diagnose_OperationCell.h
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diagnose_Operation.h"

typedef void(^setData)();

@interface Diagnose_OperationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *table;

@property(nonatomic,strong)Diagnose_Operation *oper;
@property(nonatomic,strong) setData initData;

@end
