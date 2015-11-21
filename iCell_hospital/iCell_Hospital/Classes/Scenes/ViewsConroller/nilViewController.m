//
//  nilViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/21.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "nilViewController.h"

@interface nilViewController ()

@end

@implementation nilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    imgView.center = self.view.center;
    
    imgView.image = [UIImage imageNamed:@"meiwang.gif"];
    
    
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
