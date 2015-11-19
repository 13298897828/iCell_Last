//
//  HYWeatherLiveView.h
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYWeatherLiveView : UIView

- (void)updateWeatherWithInfo:(AMapLocalWeatherLive *)liveInfo;

@end
