//
//  Diagnose_SicknessCell.h
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diagnose_Sickness.h"

typedef void(^setData)();

@interface Diagnose_SicknessCell : UITableViewCell

@property(nonatomic,strong)Diagnose_Sickness *sickness;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *causeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *drugLabel;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(nonatomic,strong) setData del;

@end
