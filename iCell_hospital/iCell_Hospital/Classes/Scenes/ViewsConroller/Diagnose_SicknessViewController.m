//
//  Diagnose_SicknessViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_SicknessViewController.h"
#import "ChatViewController.h"
@interface Diagnose_SicknessViewController ()<UISearchBarDelegate>

@end

@implementation Diagnose_SicknessViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设定cell根据内容自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;

    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"Diagnose_SicknessCell" bundle:nil] forCellReuseIdentifier:@"sicknessCellId"];

    
 
}

-(void)viewWillAppear:(BOOL)animated{
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 200, 80, 80);
    [button setImage:[UIImage imageNamed:@"fu"] forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    
    [[UIApplication sharedApplication].keyWindow addSubview:button];
    
    //    [self.view addSubview:button];
    
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




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:@"sicknessCellId" forIndexPath:indexPath];
    
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_cell.searchBar endEditing:YES];
}





//设置cell的出现动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.layer.transform = CATransform3DMakeScale(0.6, 0.8, 1);
    [UIView animateWithDuration:.5 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            [view removeFromSuperview];
            
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
