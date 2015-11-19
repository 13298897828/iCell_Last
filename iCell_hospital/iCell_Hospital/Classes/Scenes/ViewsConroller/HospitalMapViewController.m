//
//  HospitalMapViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalMapViewController.h"

@interface HospitalMapViewController ()

@property(nonatomic,strong)HospitalMapView *map;

@end


@implementation HospitalMapViewController

- (void)loadView{
    if (self.hospital !=nil) {
        self.map = [[HospitalMapView alloc] initWithFrame:[UIScreen mainScreen].bounds Hospital:self.hospital];

        self.view = self.map;
    }else{
        self.map = [[HospitalMapView alloc] initWithFrame:[UIScreen mainScreen].bounds Hospital:nil];
        [self.map searchNearbyHospital];
        self.view = self.map;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}





@end
