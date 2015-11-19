//
//  MedicineViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "MedicineViewController.h"
NSString *httpUrl = @"http://apis.baidu.com/tngou/drug/search";
//NSString *httpArg = @"name=drug&keyword=%E8%83%B6%E5%9B%8A&page=1&rows=20&type=name";
@interface MedicineViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *searchMedicineTableView;
@end

@implementation MedicineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

//    _MedicineSearchBar.delegate = self;
//    
//    _MedicineSearchBar.keyboardType = UIKeyboardTypeDefault;

    _MedicineSearchBar.delegate = self;
    
    _MedicineSearchBar.keyboardType = UIKeyboardTypeDefault;
    
    _searchMedicineTableView.delegate = self;
    
    _searchMedicineTableView.dataSource = self;
    
    [self.searchMedicineTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MedicineSearchCell"];
    
  
    
    
}

#pragma mark - 点击搜索按钮 搜索结果
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    

     NSString *typeString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)_MedicineSearchBar.text,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    
    NSString *urlString = [NSString stringWithFormat:@"name=drug&keyword=%@&page=1&rows=20&type=name",typeString];
    
    [[MedicineHelper sharedManager] request:httpUrl withHttpArg:urlString];
    
  
    
    [MedicineHelper sharedManager].result = ^{
        
        [self.searchMedicineTableView reloadData];
        
    };
    

    
    [DiagnoseManager sharedDiagnoseManager].digResult = ^(){
        
        NSLog(@"hahaha");
    };
    
}
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    
//    
//     NSString *typeString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)_MedicineSearchBar.text,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
//    
//    NSString *urlString = [NSString stringWithFormat:@"name=drug&keyword=%@&page=1&rows=20&type=name",typeString];
//    
//    [[MedicineHelper sharedManager] request:httpUrl withHttpArg:urlString];
//    
//}

#pragma mark - 返回搜索结果
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%ld",[MedicineHelper sharedManager].MedicineInfoArray.count);
    return [MedicineHelper sharedManager].MedicineInfoArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MedicineSearchCell"];
    
    Medicine *medicine = [MedicineHelper sharedManager].MedicineInfoArray[indexPath.row];
    
    cell.textLabel.text = medicine.name;
    cell.detailTextLabel.text = medicine.ID;
    NSLog(@"%@",medicine.name);
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
