//
//  Diagnose_OperationViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_OperationViewController.h"

@interface Diagnose_OperationViewController ()

@property(nonatomic,strong)Diagnose_OperationCell *cell;

@end

@implementation Diagnose_OperationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设定cell根据内容自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"Diagnose_OperationCell" bundle:nil] forCellReuseIdentifier:@"operateCellId"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:@"operateCellId" forIndexPath:indexPath];
    
    _cell.initData = ^(){
        [tableView reloadData];
    };
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell.table.hidden = YES;
}


//设置cell的出现动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.layer.transform = CATransform3DMakeScale(0.6, 0.8, 1);
    [UIView animateWithDuration:.5 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
