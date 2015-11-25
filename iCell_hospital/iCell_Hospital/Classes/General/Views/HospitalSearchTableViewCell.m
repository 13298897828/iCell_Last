//
//  HospitalSearchTableViewCell.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalSearchTableViewCell.h"

@interface HospitalSearchTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *nearHosLabel;
@property (strong, nonatomic) IBOutlet UILabel *searchHosLabel;


@end

@implementation HospitalSearchTableViewCell

- (void)awakeFromNib {
    
//    夜间模式
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        
        self.nearHosLabel.normalTextColor= [UIColor blackColor];;
        self.searchHosLabel.normalTextColor=  [UIColor blackColor];;
        
        self.nearHosLabel.nightTextColor= [UIColor lightTextColor];
        self.searchHosLabel.nightTextColor= [UIColor lightTextColor];
        
        self.contentView.normalBackgroundColor = [UIColor whiteColor];
        self.contentView.nightBackgroundColor = [UIColor blackColor];
    }];

    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
