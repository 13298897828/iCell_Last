//
//  HospitalSecondTableViewCell.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalSecondTableViewCell.h"
@interface HospitalSecondTableViewCell ()<MAMapViewDelegate,CLLocationManagerDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *hosIMageView;
@property (strong, nonatomic) IBOutlet UILabel *hosNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *hosLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *hosMtypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *hosDistanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *yibaoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *levelImageView;

@property(nonatomic,strong)HospitalMapView *map;

@end

@implementation HospitalSecondTableViewCell


- (void)setHospital:(Hospital *)hospital{
    
    NSString *imgURl = [@"http://tnfs.tngou.net/img" stringByAppendingString:hospital.img];
    [self.hosIMageView sd_setImageWithURL:[NSURL URLWithString:imgURl]];
    //    缓存图片
    NSUserDefaults *user = [[NSUserDefaults alloc] init];
    if ([HospitalHelper isExistenceNetwork]) {
        if ([user objectForKey:hospital.img]) {
            
        }else{
        NSData *data = UIImageJPEGRepresentation(self.hosIMageView.image, 0.5);
        [user setObject:data forKey:hospital.img];
        }

        
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([hospital.y doubleValue], [hospital.x doubleValue]));
        
        MAMapPoint point2 =[HospitalHelper sharedHospitalHelper].myPoint;
        
        if (MAMetersBetweenMapPoints(point1, point2)*0.001 >99) {
            self.hosDistanceLabel.text = @"距离您99+km";
        }else{
            self.hosDistanceLabel.text = [NSString stringWithFormat:@"距离您%.1fkm",MAMetersBetweenMapPoints(point1, point2)*0.001];
        }

    }else{
        
        [self.hosIMageView setImage:[UIImage imageWithData:[user objectForKey:hospital.img]]];
        
        
        self.hosDistanceLabel.text = @"距离您99+km";
    }
    
    self.hosNameLabel.text =hospital.name;
    
    self.hosLevelLabel.text = hospital.level;
    if ([hospital.level rangeOfString:@"三级甲等"].location != NSNotFound) {
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"sanjia"];
        self.hosLevelLabel.hidden = YES;
    }
    else if ([hospital.level rangeOfString:@"二级甲等"].location != NSNotFound){
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"erjia"];
        self.hosLevelLabel.hidden = YES;
    }
    else if ([hospital.level rangeOfString:@"一级甲等"].location != NSNotFound){
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"yijia"];
        self.hosLevelLabel.hidden = YES;
    }
    else if ([hospital.level rangeOfString:@"三级乙等"].location != NSNotFound){
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"sanyi"];
        self.hosLevelLabel.hidden = YES;
    }
    else if ([hospital.level rangeOfString:@"二级乙等"].location != NSNotFound){
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"eryi"];
        self.hosLevelLabel.hidden = YES;
    }
    else if ([hospital.level rangeOfString:@"一级乙等"].location != NSNotFound){
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"yiyi"];
        self.hosLevelLabel.hidden = YES;
    }
    else if ([hospital.level rangeOfString:@"其他"].location != NSNotFound){
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"qita"];
        self.hosLevelLabel.hidden = YES;
    }
    else if ([hospital.level rangeOfString:@"三级丙等"].location != NSNotFound){
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"sanbing"];
        self.hosLevelLabel.hidden = YES;
    }
    else if ([hospital.level rangeOfString:@"二级丙等"].location != NSNotFound){
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"erbing"];
        self.hosLevelLabel.hidden = YES;
    }
    else if ([hospital.level rangeOfString:@"一级丙等"].location != NSNotFound){
        self.levelImageView.hidden = NO;
        self.levelImageView.image = [UIImage imageNamed:@"yibing"];
        self.hosLevelLabel.hidden = YES;
    }
    else{
        self.hosLevelLabel.hidden = NO;
        self.levelImageView.hidden = YES;
    }
    if ([hospital.mtype rangeOfString:@"居民医保"].location !=NSNotFound) {

  

        self.yibaoImageView.image = [UIImage imageNamed:@"bao"];

        self.yibaoImageView.hidden = NO;
        self.hosMtypeLabel.hidden = YES;
    }else{
        self.yibaoImageView.hidden = NO;
        self.yibaoImageView.image =[UIImage imageNamed:@"xian-1"];
       
        self.hosMtypeLabel.hidden = YES;

    }
    self.hosMtypeLabel.text = hospital.mtype;
    
}



- (void)awakeFromNib {
    self.map = [[HospitalMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Hospital:nil];
    [self.contentView addSubview: self.map];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        
        self.contentView.nightBackgroundColor = [UIColor blackColor];
        self.contentView.normalBackgroundColor = [UIColor whiteColor];
        
        self.hosNameLabel.normalTextColor  = [UIColor blackColor];
        self.hosNameLabel.nightTextColor = [UIColor lightTextColor];
        
        self.hosDistanceLabel.normalTextColor = [UIColor blackColor];
        self.hosDistanceLabel.nightTextColor = [UIColor lightTextColor];
        
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
