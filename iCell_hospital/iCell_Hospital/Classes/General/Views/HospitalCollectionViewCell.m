//
//  HospitalCollectionViewCell.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalCollectionViewCell.h"

@interface HospitalCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *hosImageView;
@property (strong, nonatomic) IBOutlet UILabel *hosNameLabel;

@end

@implementation HospitalCollectionViewCell

- (void)setHospital:(Hospital *)hospital{
    NSString *imgURl = [@"http://tnfs.tngou.net/img" stringByAppendingString:hospital.img];
    [self.hosImageView sd_setImageWithURL:[NSURL URLWithString:imgURl]];
    
    self.hosNameLabel.text = hospital.name;
    
}

- (void)awakeFromNib {
    // Initialization code
}

@end
