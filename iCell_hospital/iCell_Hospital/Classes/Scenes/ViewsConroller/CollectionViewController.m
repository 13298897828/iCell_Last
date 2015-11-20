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


@property (strong, nonatomic) HospitalCollectList *v1;
@property (strong, nonatomic) MedicineCollectList *v2;
@property (strong, nonatomic) SicknessCollectList *v3;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DBManager sharedManager] openDB];
    
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(tapAction:) forControlEvents:(UIControlEventValueChanged)];
    
    _v1 = [HospitalCollectList new];
    _v1.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height );
    
    _v2 = [MedicineCollectList new];
    _v2.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height );
    
    _v3 = [SicknessCollectList new];
    _v3.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height );
    
    [self addChildViewController:_v1];
    [self addChildViewController:_v2];
    [self addChildViewController:_v3];
    
    [self.view addSubview:_v1.view];

    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        _v1.view.normalBackgroundColor = [UIColor whiteColor];
        _v1.view.nightBackgroundColor = UIColorFromRGB(0x343434);
        _v2.view.normalBackgroundColor = [UIColor whiteColor];
        _v2.view.nightBackgroundColor = UIColorFromRGB(0x343434);
        _v3.view.normalBackgroundColor = [UIColor whiteColor];
        _v3.view.nightBackgroundColor = UIColorFromRGB(0x343434);
 
    
    }];

}

-(void)tapAction:(UISegmentedControl *)sender{
    
    NSLog(@"%@",self.view.subviews);
        [[DBManager sharedManager] openDB];
    UIViewController * vc = self.childViewControllers[sender.selectedSegmentIndex];
    [[self.view.subviews lastObject] removeFromSuperview];
    [self.view addSubview:vc.view];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [[DBManager sharedManager] closeDB];
}

//返回
- (IBAction)goBack:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
