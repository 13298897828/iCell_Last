//
//  WeatherViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "WeatherViewController.h"

#define kHeightRatio 0.42
@interface WeatherViewController()<AMapSearchDelegate>

@property (nonatomic, strong) HYWeatherLiveView *weatherLiveView;
@property (nonatomic, strong) HYWeatherForcastView *weatherForecastView;
@property (nonatomic, strong) AMapSearchAPI *search;
@end

@implementation WeatherViewController


- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response
{
    if (request.type == AMapWeatherTypeLive)
    {
        if (response.lives.count == 0)
        {
            return;
        }
        
        AMapLocalWeatherLive *liveWeather = [response.lives firstObject];
        if (liveWeather != nil)
        {
            [self.weatherLiveView updateWeatherWithInfo:liveWeather];
        }
    }
    else
    {
        if (response.forecasts.count == 0)
        {
            return;
        }
        
        AMapLocalWeatherForecast *forecast = [response.forecasts firstObject];
        
        if (forecast != nil)
        {
            [self.weatherForecastView updateWeatherWithInfo:forecast];
        }
    }
}

#pragma mark - Utility

- (void)searchLiveWeather
{
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
//    request.city                      =   [HospitalHelper sharedHospitalHelper].currentCityName;
    request.city                      =  @"大庆";

    request.type                      = AMapWeatherTypeLive;
    
    [self.search AMapWeatherSearch:request];
}

- (void)searchForecastWeather
{
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
//    request.city                      =   [HospitalHelper sharedHospitalHelper].currentCityName;
    request.city                      =  @"大庆";

    request.type                      = AMapWeatherTypeForecast;
    
    [self.search AMapWeatherSearch:request];
}

#pragma mark - Initialization

- (void)initWeatherLiveView
{
    self.weatherLiveView = [[HYWeatherLiveView alloc] init];
    [self.weatherLiveView setBackgroundColor:[UIColor colorWithRed:84/255.0 green:142/255.0 blue:212/255.0 alpha:1]];
    [self.view addSubview:self.weatherLiveView];
    
    [self.weatherLiveView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.weatherLiveView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.weatherLiveView autoPinEdgeToSuperviewEdge:ALEdgeRight];
}

- (void)initWeatherForecastView
{
    self.weatherForecastView = [[HYWeatherForcastView alloc] init];
    [self.weatherForecastView setBackgroundColor:[UIColor colorWithRed:84/255.0 green:142/255.0 blue:212/255.0 alpha:1]];
    [self.view addSubview:self.weatherForecastView];
    
    [self.weatherForecastView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.weatherForecastView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.weatherForecastView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.weatherForecastView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.weatherLiveView withOffset:5.0];
    [self.weatherForecastView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.weatherLiveView withMultiplier:kHeightRatio];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AMapSearchServices sharedServices].apiKey = @"a7e74608b4423098e744ca60a5ce5f79";
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initWeatherLiveView];
    [self initWeatherForecastView];
    
    [self searchLiveWeather];
    [self searchForecastWeather];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(10, 20, 40, 30);
    button.tintColor = [UIColor whiteColor];
    [button setTitle:@"返回" forState:(UIControlStateNormal)];
    
    [button addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}
-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
