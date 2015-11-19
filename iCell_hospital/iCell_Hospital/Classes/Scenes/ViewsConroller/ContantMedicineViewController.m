//
//  ContantMedicineViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/12.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "ContantMedicineViewController.h"
#import "DrugMapViewController.h"
@interface ContantMedicineViewController ()
 @property (nonatomic,strong)UISegmentedControl *seguement;
@end

@implementation ContantMedicineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

      self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
  
    _seguement =[[UISegmentedControl alloc]initWithItems:@[@"网上购药",@"附近药店"]];
    _seguement.frame = CGRectMake(self.view.frame.size.width / 3, 5, self.view.frame.size.width / 3, 35);
    _seguement.selectedSegmentIndex = 0;
   [self.navigationController.navigationBar addSubview: _seguement];
    [_seguement addTarget:self action:@selector(tapAction:) forControlEvents:(UIControlEventValueChanged)];

    drugstoreViewController *v1 = [drugstoreViewController new];
    v1.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height );
    DrugMapViewController *v2 = [DrugMapViewController new];
  
    [self addChildViewController:v2];
      [self addChildViewController:v1];
    v2.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height );
    [self.view addSubview:v2.view];
//    [self.view addSubview:_seguement];
}

-(void)tapAction:(UISegmentedControl *)sender{
    
 

    [self.view.subviews[0] removeFromSuperview];
    UIViewController * vc = self.childViewControllers[sender.selectedSegmentIndex];
    [self.view insertSubview:vc.view atIndex:0];
}


-(void)viewWillAppear:(BOOL)animated{
    
    
        [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
 
        [self.navigationController setNavigationBarHidden:NO animated:YES];

}

 /*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
