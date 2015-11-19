//
//  HospitalMapView.h
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hospital;
@interface HospitalMapView : UIView

- (instancetype)initWithFrame:(CGRect)frame Hospital:(Hospital *)hospital;

- (void)searchNearbyHospital;



@end
