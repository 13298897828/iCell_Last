//
//  drugstoreViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/12.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "drugstoreViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface drugstoreViewController ()<AMapSearchDelegate,AMapNearbySearchManagerDelegate,MAMapViewDelegate,MAMapViewDelegate>

@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)CLLocationManager *manager;
@property(nonatomic,strong)CLLocation  *location;

@property(nonatomic,strong)NSArray *gymLocationArr;

@property(nonatomic,strong)AMapSearchAPI *searchAPI;
@end

@implementation drugstoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化gymLocationArr
    
    self.gymLocationArr = [[NSArray alloc] init];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(goHealthList)];
    
    //添加地图
    [self addMap];
    

    
    //开始搜索
    [self search];

    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].keyWindow.subviews[1].hidden = YES;
    //开始定位
    [_manager startUpdatingLocation];
}
-(void)viewWillDisappear:(BOOL)animated{
    
//        [UIApplication sharedApplication].keyWindow.subviews[1].hidden = NO;
    
}
//添加地图
- (void)addMap{
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"a7e74608b4423098e744ca60a5ce5f79";
    
    _mapView = [[MAMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    _mapView.mapType = MAMapTypeStandard;
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        _manager = [[CLLocationManager alloc] init];
        //设置权限为使用的时候定位
        [_manager requestAlwaysAuthorization];
        //
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
    
    //显示用户位置
    _mapView.showsUserLocation = YES;
    
    //距离筛选器  设置最小的位置更新提示距离
    _manager.desiredAccuracy = 2000;
    
    //设置地图管理类的代理
    _manager.delegate = self;
    
    //设置地图代理
    _mapView.delegate = self;

    
}

//搜索
- (void)search{
    //配置用户key
    [AMapSearchServices sharedServices].apiKey = @"a7e74608b4423098e744ca60a5ce5f79";
    
    //初始化检索对象
    self.searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
    //构造AMapPOIKeywordsSearchRequest对象，设置关键字请求参数
    AMapInputTipsSearchRequest *tiprequest = [[AMapInputTipsSearchRequest alloc] init];
    tiprequest.keywords = @"药店";
    tiprequest.city = @"北京";
    //发起输入提示搜索
    [self.searchAPI AMapInputTipsSearch: tiprequest];
}

#pragma mark - searchDelegate
//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    //移除原来的大头针
    [_mapView removeAnnotations:_mapView.annotations];
    
    //获取所有的gym
    self.gymLocationArr = response.tips;
    
    if(_gymLocationArr.count == 0)
    {
        return;
    }
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld", (long)response.count];
    NSString *strtips = @"";
    for (AMapTip *p in _gymLocationArr) {
        strtips = [NSString stringWithFormat:@"%@\nTip: %@", strtips, p.name];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strtips];
//    NSLog(@"InputTips: %@", result);
    
    [self searchComplete];
}

- (void)searchComplete {
    
    for (AMapTip *p in _gymLocationArr) {
        //插一根大头针
        MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:p.location.latitude longitude:p.location.longitude];
        
        CLLocationCoordinate2D theLocation;
        theLocation.longitude = location.coordinate.longitude;
        theLocation.latitude = location.coordinate.latitude;
        //给大头针位置
        point.coordinate = theLocation;
        //给大头针标题
        point.title = p.name;
        [_mapView addAnnotation:point];
        
    }
}

#pragma mark - mapView 代理方法

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    //创建重用标识符
    static NSString *reuse = @"reuseID";
    
    //创建注释气泡
    MAPinAnnotationView *pinAnnotation = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuse];
    if (!pinAnnotation) {
        pinAnnotation = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuse];
    }
    
    pinAnnotation.animatesDrop = YES;
    
    //可以显示视图
    pinAnnotation.canShowCallout = YES;
    
    return pinAnnotation;
}



- (void)goHealthList{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - searchBar 的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self search];
}


//不写会崩
-(void)dealloc
{
    self.mapView = nil;
    self.manager = nil;
    _mapView.delegate = nil;
    _manager.delegate = nil;
}



- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存过高");
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
