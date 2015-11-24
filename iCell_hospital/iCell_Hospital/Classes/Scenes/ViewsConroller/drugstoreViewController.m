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
#define APIKey @"a7e74608b4423098e744ca60a5ce5f79"
@interface drugstoreViewController ()<AMapSearchDelegate,AMapNearbySearchManagerDelegate,MAMapViewDelegate,MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    MAMapView *_mapView;
    //控制跟踪模式
    UIButton *_locationButton;
    //搜索类
    AMapSearchAPI *_search;
    UIButton *_searchButton;
    //记录用户位置
    CLLocation *_currentLocation;
    //展示搜索结果
    UITableView *_tableView;
    //目的地坐标的Annotation
    MAPointAnnotation *_destionPoint;
    //存储路线
    NSArray *_pathPolylines;
    
    
}
//存储结果
@property(nonatomic,strong)NSMutableArray *pois;
@property(nonatomic,strong)NSMutableArray *annotations;
@property (nonatomic,strong)CLLocationManager *manager;
@property(nonatomic,strong)NSArray *gymLocationArr;

@end

@implementation drugstoreViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.gymLocationArr = [[NSArray alloc] init];
    
    [self loadAllViews];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    
}


-(void)loadAllViews{
    
    [MAMapServices sharedServices].apiKey = APIKey;
    [AMapSearchServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)*0.6)];
    _mapView.delegate = self;
    _mapView.mapType = MAMapTypeStandard;
    //中心经纬度坐标
    //_mapView.centerCoordinate =
    //缩放级别
    _mapView.zoomLevel = 14;
    //罗盘原点位置
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
    //比例尺原点位置
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
    //开启定位
    _mapView.showsUserLocation = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        _manager = [[CLLocationManager alloc] init];
        //设置权限为使用的时候定位
        [_manager requestAlwaysAuthorization];
        //
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        
     }
    
    _manager.delegate = self;
    
    [self.view addSubview:_mapView];
    
    //也需要设置APIKey
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.bounds)*0.6, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)*0.4) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    
}




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





-(void)viewDidAppear:(BOOL)animated{
    
    AMapPOIAroundSearchRequest * request = [[AMapPOIAroundSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    request.keywords = @"医疗";
    request.radius = 50000;
    request.sortrule = 0; 
    request.requireExtension = YES;
    [_search AMapPOIAroundSearch:request];
    
}




#pragma mark --Action

-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//修改用户的定位模式
-(void)locationAction{
    //模式
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow) {
        //若不是follow模式则修改
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
}

//逆地理编码
-(void)reGeoAction{
    
    //当前经纬度
    if (_currentLocation) {
        //逆地理编码搜索请求
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        request.radius = 50000;//默认1000
        request.requireExtension = YES;
        //逆地理编码查询接口
        [_search AMapReGoecodeSearch:request];
    }
}



//地理字符串解析
-(CLLocationCoordinate2D *)coordinatesForString:(NSString *)string coordinateCount:(NSUInteger *)coordinateCount parseToken:(NSString *)token{
    
    if (string == nil) {
        return NULL;
    }
    if (token == nil) {
        token = @",";
    }
    NSString *str = @"";
    if (![token isEqualToString:@","]) {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    } else {
        str = [NSString stringWithString:string];
    }
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count]/2;
    if (coordinateCount != NULL) {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i<count; i++) {
        coordinates[i].longitude = [[components objectAtIndex:2*i] doubleValue];
        coordinates[i].latitude = [[components objectAtIndex:2*i + 1] doubleValue];
    }
    return coordinates;
}


-(NSArray *)polylinesForPath:(AMapPath *)path{
    
    if (path == nil || path.steps.count == 0) {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:((AMapStep *)obj).polyline coordinateCount:&count parseToken:@";"];
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        [polylines addObject:polyline];
        free(coordinates),coordinates = NULL;
    }];
    
    return polylines;
}


-(void)routeAction:(MAPointAnnotation *)annotation{
    
    if (annotation == nil || _currentLocation == nil || _search == nil) {
        return;
    }
    AMapWalkingRouteSearchRequest  *request = [[AMapWalkingRouteSearchRequest alloc]init];
    //起始坐标
    request.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    //终点坐标
    request.destination = [AMapGeoPoint locationWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    //发起路径搜索
    [_search AMapWalkingRouteSearch:request];
 
}

#pragma mark --MapViewDelegate

-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if (annotation == _destionPoint) {
        static NSString *reuseIndetifier = @"starAnnotationID";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *resuseIndetifier = @"annotationID";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:resuseIndetifier];
        
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:resuseIndetifier];
        }
        annotationView.tintColor = [UIColor redColor];
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    return nil;
}




-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
        //获取当前经纬度
        _currentLocation = userLocation.location;
    }
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    //选中定位annotation的时候进行逆地理编码
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        //调用逆地理编码方法
        [self reGeoAction];
    }
}

-(MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineView *polylineView = [[MAPolylineView alloc]initWithPolyline:overlay];
        polylineView.lineWidth = 5;
        polylineView.strokeColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
        return polylineView;
    }
    return nil;
}

#pragma mark --AMapSearchDelegate
//搜索请求失败时
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    //    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    //    NSLog(@"%@",error);
}

//实现逆地理编码的回调函数
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    //search正确返回时
    //请求的逆地理编码结果response.regeocode
    //response 响应结果
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
    }
    //定位标注点要显示的标题
    _mapView.userLocation.title = title;
    //显示 格式化地址
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    
}

//搜索回调结果
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
   
    [_mapView removeOverlays:_pathPolylines];
    _pathPolylines = nil;
    
    [_mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    //通过AMapPOISearchResponse对象处理搜索结果
    for (AMapPOI *p in response.pois) {
        [self.pois addObject:p];
    }
    [_tableView reloadData];
}

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    
    if(response.route == nil)
    {
        return;
    }
    [_mapView removeOverlays:_pathPolylines];
    _pathPolylines = nil;
    //只显示一条
    _pathPolylines = [self polylinesForPath:response.route.paths[0]];
    [_mapView addOverlays:_pathPolylines];
    [_mapView showAnnotations:@[_destionPoint,_mapView.userLocation] animated:YES];
}



#pragma mark --TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pois.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID  = @"cellID";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    AMapPOI *poi = self.pois[indexPath.row];
    
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    
    //为点击的poi点添加标注
    AMapPOI * poi = self.pois[indexPath.row];
    _destionPoint = [[MAPointAnnotation alloc]init];
    _destionPoint.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    _destionPoint.title = poi.name;
    _destionPoint.subtitle = poi.address;
    
    [self routeAction:_destionPoint];
    
    [self.annotations addObject:_destionPoint];
    [_mapView addAnnotation:_destionPoint];
    
}


#pragma mark --懒加载

-(NSMutableArray *)pois{
    if (_pois == nil) {
        self.pois = [NSMutableArray array];
    }
    return _pois;
}
-(NSMutableArray *)annotations{
    
    if (_annotations == nil) {
        self.annotations = [NSMutableArray array];
    }
    return _annotations;
}





-(void)dealloc
{
 
    self.manager = nil;
    _mapView.delegate = nil;
    _manager.delegate = nil;
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
