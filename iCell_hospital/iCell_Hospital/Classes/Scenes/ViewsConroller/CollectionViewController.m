//
//  CollectionViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(tapAction:) forControlEvents:(UIControlEventValueChanged)];
    
    HospitalCollectList *v1 = [HospitalCollectList new];
    v1.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height );
    
    MedicineCollectList *v2 = [MedicineCollectList new];
    v2.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height );
    
    SicknessCollectList *v3 = [SicknessCollectList new];
    v3.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height );
    
    [self addChildViewController:v3];
    [self addChildViewController:v2];
    [self addChildViewController:v1];
    
    [self.view addSubview:v1.view];
    
    
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        v1.view.normalBackgroundColor = [UIColor whiteColor];
        v1.view.nightBackgroundColor = UIColorFromRGB(0x343434);
        v2.view.normalBackgroundColor = [UIColor whiteColor];
        v2.view.nightBackgroundColor = UIColorFromRGB(0x343434);
        v3.view.normalBackgroundColor = [UIColor whiteColor];
        v3.view.nightBackgroundColor = UIColorFromRGB(0x343434);
 
    
    }];
}

-(void)tapAction:(UISegmentedControl *)sender{
    
    [self.view.subviews[0] removeFromSuperview];
    UIViewController * vc = self.childViewControllers[sender.selectedSegmentIndex];
    [self.view insertSubview:vc.view atIndex:0];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
