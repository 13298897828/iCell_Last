//
//  HosipitalViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HosipitalViewController.h"
static NSString * const sampleDescription1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
static NSString * const sampleDescription2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
static NSString * const sampleDescription3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
static NSString * const sampleDescription4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";
@interface HosipitalViewController ()<UITableViewDataSource,UITableViewDelegate,EAIntroDelegate>
{
    UIView *rootView;
    EAIntroView *_intro;
    NSInteger page ;
}
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

    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        
        NSLog(@"第一次启动");
            [self showIntroWithCrossDissolve];
        
        
    }else{
        NSLog(@"不是第一次启动");
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"HospitalSearchTableViewCell" bundle:nil] forCellReuseIdentifier:searchTableID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HospitalTableViewCell" bundle:nil] forCellReuseIdentifier:collectionCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HospitalSecondTableViewCell" bundle:nil] forCellReuseIdentifier:secondTableID];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];

    [self requestDataWithCityID:@"2" page:@"1"];
    //定位开始
    if ([HospitalHelper isExistenceNetwork]) {
        
    self.hosMapView = [[HospitalMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Hospital:nil];
    [self.view addSubview:self.hosMapView];
         page = 2;
    }
//    else{
//        [self requestDataWithCityID:@"2"];
//    }
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (![HospitalHelper sharedHospitalHelper].currentCityID) {
            [HospitalHelper sharedHospitalHelper].currentCityID =@"2";
        }
        [self requestDataWithCityID:[NSString stringWithFormat:@"%@",[HospitalHelper sharedHospitalHelper].currentCityID] page:[NSString stringWithFormat:@"%ld",page++]];
    }];
    
    
}






//引导页
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"3"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"4"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"5"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"6"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    [intro showInView:self.tabBarController.view animateDuration:0.3];
}







//通知传值的方法
- (void)tongzhi:(NSNotification *)text{
    
    if (text.userInfo[@"cityID"]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [HospitalHelper sharedHospitalHelper].currentCityID =text.userInfo[@"cityID"];
         [self requestDataWithCityID:text.userInfo[@"cityID"] page:@"1"];
    });
}
    if (text.userInfo[@"cityName"]) {
         [self.hospitalCity_ProvinceButton setTitle:text.userInfo[@"cityName"]  forState:UIControlStateNormal];
    }
   
    if (text.userInfo[@"city"] ) {
        [self.hospitalCity_ProvinceButton setTitle:[text.userInfo[@"city"] stringByReplacingOccurrencesOfString:@"市" withString:@""]forState:UIControlStateNormal];
    }
    

}

- (void)requestDataWithCityID:(NSString *)cityID page:(NSString *)page{
    
    NSString *httpArg = [NSString stringWithFormat:@"id=%@&page=%@&rows=20",cityID,page];
//    NSLog(@"ID==%@",cityID);
    [[HospitalHelper sharedHospitalHelper] requestHttpUrl:kListhttpUrl withHttpArg:httpArg success:^(id data) {
        if ([page isEqualToString:@"1"]) {
        [self.hospitalListArray removeAllObjects];
        
        }
      [self.dataArray removeAllObjects];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        NSArray *array = dict[@"tngou"];
     
        for (NSDictionary *dic in array) {
            Hospital *hos = [Hospital new];
            [hos setValuesForKeysWithDictionary:dic];
            [self.hospitalListArray addObject:hos];
        }
        [self.dataArray addObject:self.hospitalListArray];
        
        if ([HospitalHelper isExistenceNetwork]) {
            dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
        });
        }else{
            [self.tableView reloadData];
        }
        
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
