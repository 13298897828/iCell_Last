//
//  MedicineViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "MedicineViewController.h"
#import "EFAnimationViewController.h"
#import <UIImageView+WebCache.h>
#import "ScanViewController.h"
#import "ChatViewController.h"
@interface MedicineViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,assign)NSInteger num;
@property (weak, nonatomic) IBOutlet UIButton *drugstore;
@property (nonatomic, strong) EFAnimationViewController *viewController;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;



@end

@implementation MedicineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:58/ 255. green:109/ 255. blue:222 / 255. alpha:1.0];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.hidesBottomBarWhenPushed = YES;
//    药店界面五个轮播
    self.viewController = ({
        EFAnimationViewController *viewController = [[EFAnimationViewController alloc] init];
        [self.view addSubview:viewController.view];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        viewController;
    });
    [self.view bringSubviewToFront:_MedicineSearchBar];
    [self.view bringSubviewToFront:_drugstore];
    [self.view bringSubviewToFront:_scanButton];
    _MedicineSearchBar.delegate = self;
    _MedicineSearchBar.keyboardType = UIKeyboardTypeDefault;
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 200, 80, 80);
//    [button setTitle:@"哇哈哈" forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:@"fu"] forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    button.tintColor = [UIColor whiteColor];
    
    [button addTarget:self action:@selector(jumpToConsulting) forControlEvents:(UIControlEventTouchUpInside)];
    
}
#pragma mark -跳转客服界面
-(void)jumpToConsulting{
    
    ChatViewController *chat = [ChatViewController new];
    

    // 快速集成第二步，连接融云服务器
        self.hidesBottomBarWhenPushed = YES;
    [self showViewController:chat sender:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
   self.hidesBottomBarWhenPushed = NO;

    
 
}

#pragma mark - 点击搜索按钮 搜索结果
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
     NSString *typeString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)_MedicineSearchBar.text,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    
    NSString *urlString = [NSString stringWithFormat:@"name=drug&keyword=%@&page=1&rows=30&type=name",typeString];
    [[MedicineHelper sharedManager] request:kMedicineSearch withHttpArg:urlString];
    MedicineSearchResultViewController *search = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
        self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    [searchBar endEditing:YES];
    
}




#pragma mark -跳转到扫一扫
- (IBAction)scanAction:(UIBarButtonItem *)sender {
    ScanViewController *scanVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scanView"];
    [self presentViewController:scanVC animated:YES completion:nil];
    

}

#pragma mark - 收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_MedicineSearchBar endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [UIApplication sharedApplication].keyWindow.subviews[1].hidden = NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    
      [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

@end
