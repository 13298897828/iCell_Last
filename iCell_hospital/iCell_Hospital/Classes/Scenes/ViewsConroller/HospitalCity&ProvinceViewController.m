//
//  HospitalCity&ProvinceViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalCity&ProvinceViewController.h"

@interface HospitalCity_ProvinceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger index;
}
@property (strong, nonatomic) IBOutlet UITableView *provinceTableView;
@property (strong, nonatomic) IBOutlet UITableView *cityTableView;

@property(nonatomic,strong)NSMutableArray *provinceArray;
@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,strong)NSArray *citys;




@end

@implementation HospitalCity_ProvinceViewController
static NSString *const cellID = @"cellID";
+ (instancetype)sharedHospitalCity_ProvinceVC{
    static HospitalCity_ProvinceViewController *hosCity_Province = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hosCity_Province = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HospitalCity_ProvinceViewController"];
    });
    return hosCity_Province;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.provinceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    
    self.provinceTableView.tag = 100;
    self.cityTableView.tag = 200;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [self requestData];
    });
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    [gesture addTarget:self action:@selector(gestureAction)];
    self.currentCityLabel.userInteractionEnabled = YES;
    [self.currentCityLabel addGestureRecognizer:gesture];
   
}

- (void)gestureAction{
    
#warning 当前城市的cityID 存储在helper
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:[HospitalHelper sharedHospitalHelper].currentCityName,@"cityName",@"2",@"cityID", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([HospitalHelper sharedHospitalHelper].currentCityName) {
        self.currentCityLabel.text = [HospitalHelper sharedHospitalHelper].currentCityName;
    }else{
        self.currentCityLabel.text = @"定位不成功  ";
    }
    

}


- (void)requestData{
    
    
    [[HospitalHelper sharedHospitalHelper] requestHttpUrl:kCityhttpUrl withHttpArg:@"type=all" success:^(id data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dic in array) {
            HospitalCity_Province *province = [HospitalCity_Province new];
            [province setValuesForKeysWithDictionary:dic];
            [self.provinceArray addObject:province];
            [self.cityArray addObject:province.citys];
//             NSLog(@"citys==%@",province.citys);
        }
       
         self.citys = self.cityArray[index];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.provinceTableView reloadData];
            [self.cityTableView reloadData];
           
        });
        
    }];
}


#pragma mark tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return self.provinceArray.count;
    }
  
    
    return _citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (tableView.tag ==100) {
        cell.textLabel.text = ((HospitalCity_Province *)self.provinceArray[indexPath.row]).province;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    }else{
        NSArray *array = self.cityArray[index];
        NSDictionary *dict = array[indexPath.row];
        
        cell.textLabel.text =dict[@"city"];
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        index = indexPath.row;
         self.citys = self.cityArray[index];
        [self.cityTableView reloadData];
    }else{
        NSArray *array = self.cityArray[index];
//        选中的市区
        NSDictionary *dict = array[indexPath.row];
//        市区名
        NSString *cityName = dict[@"city"];
//       城市id
        NSString *cityID = dict[@"id"];
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:cityName,@"cityName",cityID,@"cityID", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dic];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
         [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    return;
}




- (IBAction)cancelPageAction:(UIButton *)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSMutableArray *)provinceArray{
    if (_provinceArray == nil) {
        _provinceArray = [NSMutableArray arrayWithCapacity:8];
    }
    return _provinceArray;
}

- (NSMutableArray *)cityArray{
    if (_cityArray == nil) {
        _cityArray = [NSMutableArray arrayWithCapacity:6];
    }
    return _cityArray;
}

@end
