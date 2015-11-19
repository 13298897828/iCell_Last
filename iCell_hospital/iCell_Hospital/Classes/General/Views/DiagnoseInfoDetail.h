//
//  DiagnoseInfoDetail.h
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diagnose_Info.h"

typedef void(^pushVC)();

@interface DiagnoseInfoDetail : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *infoImg;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *urlBtn;
@property(nonatomic,assign)CGFloat height;
- (IBAction)urlBtnAction:(UIButton *)sender;

//实体对象
@property(nonatomic,strong)Diagnose_Info *info;
//block属性
@property(nonatomic,strong)pushVC toInterest;


@end
