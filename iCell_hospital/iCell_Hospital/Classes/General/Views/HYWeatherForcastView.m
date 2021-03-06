//
//  HYWeatherForcastView.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HYWeatherForcastView.h"


@interface HYWeatherForcastView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *forecastArray;
@property (nonatomic, strong) NSDictionary *weekDict;

@end

@implementation HYWeatherForcastView

- (void)updateWeatherWithInfo:(AMapLocalWeatherForecast *)forecastInfo{
    _forecastArray = [NSArray arrayWithArray:forecastInfo.casts];
    
    if (_forecastArray !=nil)
    {
        [_tableview reloadData];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _tableview                 = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self addSubview:_tableview];
        _tableview.backgroundColor = [UIColor colorWithRed:84/255.0 green:142/255.0 blue:212/255.0 alpha:1];
        _tableview.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableview.allowsSelection = NO;
        [_tableview autoPinEdgesToSuperviewEdges];
        
        _tableview.dataSource      = self;
        _tableview.delegate        = self;
        
        _weekDict = @{@"1":@"周一",
                      @"2":@"周二",
                      @"3":@"周三",
                      @"4":@"周四",
                      @"5":@"周五",
                      @"6":@"周六",
                      @"7":@"周日"};
    }
    
    return self;
}


#pragma mark -UITableview DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"weatherIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil)
    {
        cell                             = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.contentView.backgroundColor = [UIColor colorWithRed:84/255.0 green:142/255.0 blue:212/255.0 alpha:1];
        cell.backgroundColor             = [UIColor colorWithRed:84/255.0 green:142/255.0 blue:212/255.0 alpha:1];
        cell.textLabel.textColor         = [UIColor whiteColor];
        cell.detailTextLabel.textColor   = [UIColor whiteColor];
    }
    
    AMapLocalDayWeatherForecast *dayForecast = [_forecastArray objectAtIndex:indexPath.row];
    NSString *title = [dayForecast.date substringFromIndex:5];
    NSString *subTitle = [NSString stringWithFormat:@"%@/%@",dayForecast.dayTemp ?:@"",dayForecast.nightTemp?:@""];
    
//    判断网络状态
    if (![HospitalHelper isExistenceNetwork]) {
        
        if ([[DBManager sharedManager] findForcastWeatherInDatabase].count) {
         NSDictionary* dic=[[DBManager sharedManager] findForcastWeatherInDatabase][indexPath.row];
        title = [[dic[@"date"] substringFromIndex:5]stringByAppendingString:_weekDict[dic[@"week"]]];
        
        subTitle = [NSString stringWithFormat:@"%@/%@",dic[@"dayTemp"] ?:@"",dic[@"nightTemp"]?:@""];   
        }
      
    }
    else{
        title =[title stringByAppendingString:_weekDict[dayForecast.week]];
    }
    
    title = [title stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subTitle;
    
    return cell;
}

@end
