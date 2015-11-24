//
//  HosipitalViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HosipitalViewController.h"
static NSString * const sampleDescription1 = @"你是否还在因为平时的头疼脑热不知什么原因而烦恼?你是否因为没时间去医院诊断而无奈?";
static NSString * const sampleDescription2 = @"我们有专业的医生在线,细心为你分析您的病因,帮助您解决问题,给您最专业的建议.";
static NSString * const sampleDescription3 = @"是否还在因为工作忙而忘记吃药,是不是缺一个关心您提醒您的人?没关系,请交给我们!";
static NSString * const sampleDescription4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";
@interface HosipitalViewController ()<UITableViewDataSource,UITableViewDelegate,EAIntroDelegate>
{
    UIView *rootView;
    EAIntroView *_intro;
    NSInteger _page ;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *hospitalListArray;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UIButton *addressButton;

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


    //定位开始
    if ([HospitalHelper isExistenceNetwork]) {
        
        [self requestDataWithCityID:@"2" page:@"1"];
    self.hosMapView = [[HospitalMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Hospital:nil];
    [self.view addSubview:self.hosMapView];
         _page = 2;
    }
    else{
       [self requestDataWithCityID:@"2" page:@"1"];
    }
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (![HospitalHelper sharedHospitalHelper].currentCityID) {
            [HospitalHelper sharedHospitalHelper].currentCityID =@"2";
        }
        [self requestDataWithCityID:[NSString stringWithFormat:@"%@",[HospitalHelper sharedHospitalHelper].currentCityID] page:[NSString stringWithFormat:@"%ld",_page++]];
    }];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, 40)];
    
    _addressLabel.text = @"地域";
    
    _addressButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 1, 50, 40)];
    
    [self.navigationController.navigationBar addSubview:_addressLabel];
    [self.navigationController.navigationBar addSubview: _addressButton];
    
    [_addressButton addTarget:self action:@selector(addressButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_addressButton setImage:[UIImage imageNamed:@"xiala"] forState:(UIControlStateNormal)];
    
}

-(void)addressButtonAction{
    
    [self presentViewController:[HospitalCity_ProvinceViewController sharedHospitalCity_ProvinceVC] animated:YES completion:^{
        
    }];
    
}



///引导页
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"头痛脑热,不知怎么办?";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"yindao2.jpg"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"专业医生在线解答";
    
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"yindao.jpg"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"关心您的每一天";
    page3.titleColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    page3.desc = sampleDescription3;
    page3.descColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    page3.bgImage = [UIImage imageNamed:@"yindao3.jpg"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    //
    //    EAIntroPage *page4 = [EAIntroPage page];
    //    page4.title = @"不得不去医院,又怕找不到专家?";
    //    page4.desc = sampleDescription4;
    //    page4.bgImage = [UIImage imageNamed:@"yiyuan"];
    //    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    [intro setDelegate:self];
    
    [intro showInView:self.tabBarController.view animateDuration:0.3];
    [intro.skipButton addTarget:self action:@selector(showAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    
}
- (void)intro:(EAIntroView *)introView pageEndScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex{
    
    
    if (introView.currentPageIndex == 2) {
        
        introView.scrollingEnabled = NO;
    }
}


- (void)showAction{
    
    //    //注册推送
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    
    
    
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    if ([HospitalHelper isExistenceNetwork]) {
        self.hosMapView = [[HospitalMapView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Hospital:nil];
        [self.view addSubview:self.hosMapView];
        
    }
    
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
        _addressLabel.text = [text.userInfo[@"cityName"]stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
   
    if (text.userInfo[@"city"] ) {
//        [self.hospitalCity_ProvinceButton setTitle:[text.userInfo[@"city"] stringByReplacingOccurrencesOfString:@"市" withString:@""]forState:UIControlStateNormal];
        _addressLabel.text = [text.userInfo[@"city"]stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    

}

- (void)requestDataWithCityID:(NSString *)cityID page:(NSString *)page{
    
    NSString *httpArg = [NSString stringWithFormat:@"id=%@&page=%@&rows=20",cityID,page];
//    NSLog(@"ID==%@",cityID);
    [[HospitalHelper sharedHospitalHelper] requestHttpUrl:kListhttpUrl withHttpArg:httpArg success:^(id data) {
        if (data == nil) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
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

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    cell.layer.transform = CATransform3DMakeScale(-.01, .1, 1);
//    [UIView animateWithDuration:.70 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
//}



-(void)viewWillAppear:(BOOL)animated{
    
    _addressButton.hidden = NO;
    _addressLabel.hidden = NO;
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    _addressLabel.hidden = YES;
    _addressButton.hidden = YES;
    
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
