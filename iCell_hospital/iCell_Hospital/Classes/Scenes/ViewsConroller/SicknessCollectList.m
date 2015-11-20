//
//  SicknessCollectList.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "SicknessCollectList.h"

@interface SicknessCollectList ()

@end

@implementation SicknessCollectList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"sicknessCid"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",[[DBManager sharedManager] selectAllSickness].count);
    return [[DBManager sharedManager] selectAllSickness].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sicknessCid" forIndexPath:indexPath];
    
    Diagnose_Sickness *sickness = [[DBManager sharedManager] selectAllSickness][indexPath.row];
    cell.textLabel.text = sickness.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Diagnose_SicknessViewController *sicknessVC = [Diagnose_SicknessViewController new];
    sicknessVC.cell.sickness = [[DBManager sharedManager] selectAllSickness][indexPath.row];
    
    //轻拍返回
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [sicknessVC.view addGestureRecognizer:tap];
    
    [self showViewController:sicknessVC sender:nil];
}
//轻拍返回
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //从数据库中删除
        [[DBManager sharedManager] deleteSickness:[DBManager sharedManager].sicknessArr[indexPath.row]];
        
        //删除行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
