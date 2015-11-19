//
//  HospitalDetailViewController.h
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hospital;
@interface HospitalDetailViewController : UIViewController

@property(nonatomic,strong)Hospital *hospital;

+ (instancetype)sharedHospitalDetalVC;


@end
