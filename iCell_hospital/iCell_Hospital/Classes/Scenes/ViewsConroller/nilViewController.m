//
//  nilViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/21.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "nilViewController.h"
#import <UIImage+GIF.h>

@interface nilViewController ()

@end

@implementation nilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    imgView.center = self.view.center;
   imgView.image = [UIImage sd_animatedGIFNamed:@"meiwang.gif"];
 
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imgView];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(10, 10, 100, 100);
    [button setTitle:@"返回" forState:(UIControlStateNormal)];
    
    [button addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 70)];
    label.textAlignment = 1;
    label.text = @"对不起,没有找到你查找的药品";
    [self.view bringSubviewToFront:label];
    [self.view addSubview:label];
}

-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
    
//    NSURL *url = [NSURL URLWithString:URLQ];
//    
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
//    
//    _loadimageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 250, 250)];
//    
//    _loadimageView.image = [UIImage sd_animatedGIFWithData:imageData];
//    
//    [self.view addSubview:_loadimageView];
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
