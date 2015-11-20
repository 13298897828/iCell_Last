//
//  HosipitalViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HosipitalViewController.h"

@interface HosipitalViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *hospitalListArray;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property (strong, nonatomic) IBOutlet UIButton *hospitalCity_ProvinceButton;

@property(nonatomic,strong)NSString *cityName;

@property(nonatomic,strong)HospitalMapView *hosMapView;




@end

@implementation HosipitalViewController

static NSString *const collectionCellID=@"collectionID";

static NSString *const secondTableID = @"secondTableID";

static NSString *const searchTableID = @"searchTableID";

+ (instancetype)sharedHospitalViewController{
    static HosipitalViewController *hospitalVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hospitalVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HosipitalViewController"];
    });
    return hospitalVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"HospitalSearchTableViewCell" bundle:nil] forCellReuseIdentifier:searchTableID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HospitalTableViewCell" bundle:nil] forCellReuseIdentifier:collectionCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HospitalSecondTableViewCell" bundle:nil] forCellReuseIdentifier:secondTableID];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];

    
//    [self requestDataWithCityID:@"2"];
    //定位开始
    self.hosMapView = [[HospitalMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Hospital:nil];
    [self.view addSubview:self.hosMapView];
    
}



//通知传值的方法
- (void)tongzhi:(NSNotification *)text{
    
    if (text.userInfo[@"cityID"]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [self requestDataWithCityID:text.userInfo[@"cityID"]];
    });
}

   
    if (text.userInfo[@"cityName"]) {
         [self.hospitalCity_ProvinceButton setTitle:text.userInfo[@"cityName"]  forState:UIControlStateNormal];
    }
   
    if (text.userInfo[@"city"] ) {
        [self.hospitalCity_ProvinceButton setTitle:[text.userInfo[@"city"] stringByReplacingOccurrencesOfString:@"市" withString:@""]forState:UIControlStateNormal];
    }
    

}

- (void)requestDataWithCityID:(NSString *)cityID{
    
    NSString *httpArg = [NSString stringWithFormat:@"id=%@&page=1&rows=20",cityID];
//    NSLog(@"ID==%@",cityID);
    [[HospitalHelper sharedHospitalHelper] requestHttpUrl:kListhttpUrl withHttpArg:httpArg success:^(id data) {
        
        [self.hospitalListArray removeAllObjects];
        [self.dataArray removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        NSArray *array = dict[@"tngou"];
     
        for (NSDictionary *dic in array) {
            Hospital *hos = [Hospital new];
            [hos setValuesForKeysWithDictionary:dic];
            [self.hospitalListArray addObject:hos];
        }
        [self.dataArray addObject:self.hospitalListArray];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    }];
}



//显示选择地域界面
- (IBAction)showHospitalCity_ProvinceAction:(UIButton *)sender {
    [self presentViewController:[HospitalCity_ProvinceViewController sharedHospitalCity_ProvinceVC] animated:YES completion:^{
        
    }];
}


#pragma mark tableView协议方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HospitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionCellID forIndexPath:indexPath];
        cell.dataArray = self.hospitalListArray;
        cell.fatherViewController =self;
        
        return cell;
    }
    if (indexPath.section == 1) {
        HospitalSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchTableID forIndexPath:indexPath];
        //    给视图添加手势
        UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction1:)];
        [cell.nearHospitalView addGestureRecognizer:gesture1];
        
        UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction2:)];
        [cell.searchHospitalView addGestureRecognizer:gesture2];
        
        return cell;
    }
    
    if (indexPath.section == 2) {
          HospitalSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:secondTableID forIndexPath:indexPath];
    cell.hospital = self.hospitalListArray[indexPath.row];
    return cell;
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return self.dataArray.count;
    }
    if (section == 1) {
        return self.dataArray.count;
    }
    return  self.hospitalListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 300;
    }
    else if(indexPath.section == 1){
        return 50;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return;
    }
    else{
    [HospitalDetailViewController sharedHospitalDetalVC].hospital  = self.hospitalListArray[indexPath.row];
        
        if(![self.navigationController.topViewController isKindOfClass:[HospitalDetailViewController class]]) {
            [self.navigationController pushViewController:[HospitalDetailViewController sharedHospitalDetalVC] animated:YES];
        }
    
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.layer.transform = CATransform3DMakeScale(-.01, .1, 1);
    [UIView animateWithDuration:.70 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

#pragma marki 手势方法
- (void)gestureAction2:(UITapGestureRecognizer *)sender{
    HospitalSearchViewController *searchVC = [HospitalSearchViewController sharedHospitalSearchVC];
    [self.navigationController pushViewController:searchVC animated:YES];
}


- (void)gestureAction1:(UITapGestureRecognizer *)sender{
    HospitalMapViewController *mapVC =[HospitalMapViewController new];

    [self.navigationController pushViewController:mapVC animated:YES];
}

//懒加载
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)hospitalListArray{
    if (_hospitalListArray == nil) {
        _hospitalListArray = [NSMutableArray arrayWithCapacity:8];
    }
    return _hospitalListArray;
}

@end
