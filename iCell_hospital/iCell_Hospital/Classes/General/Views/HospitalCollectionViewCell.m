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
    
    
//    缓存图片
    NSUserDefaults *user = [[NSUserDefaults alloc] init];
    if ([HospitalHelper isExistenceNetwork]) {
        
    [self.hosImageView sd_setImageWithURL:[NSURL URLWithString:imgURl]];
    NSData *data = UIImageJPEGRepresentation(self.hosImageView.image, 1.0);
    [user setObject:data forKey:hospital.img];   
    
    }else{
        [self.hosImageView setImage:[UIImage imageWithData:[user objectForKey:hospital.img]]];
   
    }
    
    
    
    self.hosNameLabel.text = hospital.name;
    
}

- (void)awakeFromNib {
    // Initialization code
}

@end
