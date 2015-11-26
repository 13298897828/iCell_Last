//
//  HospitalSearchViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalSearchViewController.h"

@interface HospitalSearchViewController ()<UISearchBarDelegate>
{
    NSString *currentHosName;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property(nonatomic,strong)NSMutableArray *hosArray;

@end

@implementation HospitalSearchViewController
static NSString *const cellID = @"cellID";
static NSString *const cell2 = @"ID";
+ (instancetype)sharedHospitalSearchVC{
  static  HospitalSearchViewController *hospitalSearchVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hospitalSearchVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HospitalSearchViewController"];
    });
    return hospitalSearchVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"HospitalSecondTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell2];
    self.searchBar.delegate = self;
    
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        self.tableView.subviews[0].nightBackgroundColor = UIColorFromRGB(0x343434);
        self.tableView.subviews[0].normalBackgroundColor = [UIColor whiteColor];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.searchBar.text = @"";
    [self.hosArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hosArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Hospital *hospital = self.hosArray[indexPath.row];
    if (hospital.name == nil) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell2];
        cell.textLabel.text = @"未搜索到相关医院";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    HospitalSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.hospital = hospital;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (((Hospital *)self.hosArray[indexPath.row]).name == nil) {
        return;
    }
    [HospitalDetailViewController sharedHospitalDetalVC].hospital = self.hosArray[indexPath.row];
    [self.navigationController pushViewController:[HospitalDetailViewController sharedHospitalDetalVC] animated:YES];
}

#pragma mark searchBar的代理方法

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
          [self requestData:searchBar.text];
    });
  
    searchBar.showsCancelButton = NO;
     [searchBar resignFirstResponder];
}

- (void)requestData:(NSString *)hosName{

    if ( [hosName isEqualToString:currentHosName] || [hosName isEqualToString:@""]) {
        return;
    }
    currentHosName = hosName;

    NSString *transformString =[hosName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet controlCharacterSet]];
    NSString *httpArg = [NSString stringWithFormat:@"name=%@",transformString];
    Hospital *hospital = [Hospital new];

    [[HospitalHelper sharedHospitalHelper] requestHttpUrl:kHospitalName withHttpArg:httpArg success:^(id data) {
        [self.hosArray removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (dict.allKeys.count == 1) {
            if (self.hosArray.count == 0) {
                [self.hosArray addObject: hospital];
            }
            
        }else{
        [hospital setValuesForKeysWithDictionary:dict];
        [self.hosArray addObject:hospital];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    

    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text = @"";
    [self.hosArray removeAllObjects];
    [self.tableView reloadData];
    
    [searchBar resignFirstResponder]; // 丢弃第一使用者
}

#pragma mark - 实现监听开始输入的方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    for(id cc in [_searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }

   
    return YES;
}
#pragma mark - 实现监听输入完毕的方法
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self requestData:searchBar.text];
    });

    return YES;
}




- (NSMutableArray *)hosArray{
    if (_hosArray == nil) {
        _hosArray = [NSMutableArray arrayWithCapacity:6];
    }
    return _hosArray;
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
