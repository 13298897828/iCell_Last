//
//  HospitalMapView.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalMapView.h"

@interface HospitalMapView ()<MAMapViewDelegate,CLLocationManagerDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    CLLocationManager *_locationManager;
    AMapReGeocode *_reGeocode;
}
@property (nonatomic, strong) AMapSearchAPI *search;

@property(nonatomic,strong)NSMutableArray  *nearHosDetailArray;

@end

@implementation HospitalMapView

- (instancetype)initWithFrame:(CGRect)frame Hospital:(Hospital *)hospital;{
    if (self = [super initWithFrame:frame]) {
        [self addAllViews:hospital];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self getCityNameInTheMapView];
        });
        
    }
    return self;
}


- (void)addAllViews:(Hospital *)hospital{
    _locationManager = [[CLLocationManager alloc] init];
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"a7e74608b4423098e744ca60a5ce5f79";
    
    _mapView = [[MAMapView alloc] initWithFrame:self.frame];
    _mapView.delegate = self;
    
    [self addSubview:_mapView];
    
    _mapView.showsUserLocation  = YES;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow];
    _mapView.zoomLevel = 15;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        _locationManager = [[CLLocationManager alloc] init];
        //设置权限为使用的时候定位
        [_locationManager requestAlwaysAuthorization];
        //
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }

    
    //距离筛选器  设置最小的位置更新提示距离
    _locationManager.desiredAccuracy = 2000;
    
    //设置地图管理类的代理
    _locationManager.delegate = self;
    
    //    当前经纬度
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude));
    
    //    将经纬度赋值给工具类，以便使用
    [HospitalHelper sharedHospitalHelper].myPoint = point2;
    
    if (hospital !=nil) {
        
        _mapView.centerCoordinate = CLLocationCoordinate2DMake([hospital.y doubleValue], [hospital.x doubleValue]);
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([hospital.y doubleValue], [hospital.x doubleValue]);
        a1.coordinate = coordinate;
        a1.title = hospital.name;
        a1.subtitle = hospital.address;
        NSMutableArray *annotations = [NSMutableArray array];
        [annotations addObject:a1];
        
        [_mapView addAnnotation:a1];
        
        [_mapView showAnnotations:annotations animated:YES];
        
    }
    
    
}

#pragma mark AMapSearchDelegate

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != nil){
        _reGeocode = response.regeocode;
    }
            //获取城市
    
            NSString *city =_reGeocode.addressComponent.city;
//    NSLog(@"%@",city);
            if (!city) {

            //四大直辖市的城市信息无法通过city获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
    
            city = _reGeocode.addressComponent.province;
    
                }
//    当前城市名
                 [HospitalHelper sharedHospitalHelper].currentCityName = city;
#warning 根据定位所得城市取得城市ID
                 //添加 字典，将label的值通过key值设置传递
                 NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"cityID" ,city,@"city",nil];
    
                 //创建通知
                 NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dic];
                 //通过通知中心发送通知
                 [[NSNotificationCenter defaultCenter] postNotification:notification];

}







#pragma mark获取当前城市
- (void)getCityNameInTheMapView{
    [AMapSearchServices sharedServices].apiKey = @"a7e74608b4423098e744ca60a5ce5f79";
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude: _locationManager.location.coordinate.latitude longitude: _locationManager.location.coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];

}


#pragma mark 搜索附近医院
- (void)searchNearbyHospital{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self requestNeabyHospitalData];
    });
    

}

- (void)requestNeabyHospitalData{
    NSString *httpArg = [NSString stringWithFormat:@"x=%f&y=%f&page=1&rows=20",_locationManager.location.coordinate.longitude,_locationManager.location.coordinate.latitude];
    [[HospitalHelper sharedHospitalHelper] requestHttpUrl:kLocationhttpUrl withHttpArg:httpArg success:^(id data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *nearHosArray = dict[@"tngou"];
        for (NSDictionary *dic in nearHosArray) {
            Hospital *hospital = [Hospital new];
            [hospital setValuesForKeysWithDictionary:dic];
            [self.nearHosDetailArray addObject:hospital];
        }
   
        NSMutableArray *annotations = [NSMutableArray array];
        
        for (Hospital *hos in self.nearHosDetailArray) {
           CLLocationCoordinate2D coordinate= CLLocationCoordinate2DMake([hos.y doubleValue], [hos.x doubleValue]);
            MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
            a1.subtitle = hos.address;
            a1.coordinate = coordinate;
            a1.title      = hos.name;
            [annotations addObject:a1];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
        });
        
    }];
}


//放置大头针的代理方法
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor                         =MAPinAnnotationColorPurple;
       
        return annotationView;
    }
    
    return nil;

}

- (NSMutableArray *)nearHosDetailArray{
    if (_nearHosDetailArray ==nil) {
        _nearHosDetailArray = [NSMutableArray arrayWithCapacity:6];
    }
    return _nearHosDetailArray;
}


@end
