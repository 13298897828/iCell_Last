//
//  SicknessCollectList.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "SicknessCollectList.h"
#import "collectionDignoseView.h"
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
 
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        
        cell.contentView.nightBackgroundColor = UIColorFromRGB(0x343434);
        cell.contentView.normalBackgroundColor = [UIColor whiteColor];
        cell.textLabel.nightBackgroundColor = UIColorFromRGB(0x343434);
        cell.textLabel.normalBackgroundColor = [UIColor whiteColor];
        cell.textLabel.normalTextColor  = [UIColor blackColor];
        cell.textLabel.nightTextColor = [UIColor lightTextColor];
    }];


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 

    collectionDignoseView *dignose = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"dignose"];
    
    dignose.view.backgroundColor = [UIColor whiteColor];
    Diagnose_Sickness *sick = [[DBManager sharedManager] selectAllSickness][indexPath.row];


    dignose.sickness = sick;

 
    Diagnose_SicknessViewController *sicknessVC = [Diagnose_SicknessViewController new];
    NSArray *arr = [[DBManager sharedManager] selectAllSickness];
    sicknessVC.cell.sickness = arr[indexPath.row];
    NSLog(@"%@",arr[indexPath.row]);
    
    //隐藏部分
//    sicknessVC.cell.searchBar.hidden = YES;
//    sicknessVC.cell.collectBtn.hidden = YES;
 
    
    //轻拍返回
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [dignose.view addGestureRecognizer:tap];
    
    [self showViewController:dignose sender:nil];
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
