//
//  TabViewController.m
//  TabbarDemo
//
//  Created by huangwenchen on 15/8/31.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import "TabViewController.h"
#import "FeedbackViewController.h"
#import "SetAlertViewController.h"
#import "WeatherViewController.h"
#import "collectionTableViewController.h"
@interface TabViewController ()<UITabBarControllerDelegate>

@property (weak,nonatomic)UIVisualEffectView * backgroundview;
@property (weak,nonatomic)UIView * bottomView;
@property (weak,nonatomic)UIImageView * closeImageview;
@property (strong,nonatomic)NSMutableArray * menuviewsArray;
@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * midImage = [UIImage imageNamed:@"mid"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UITabBarItem * item = obj;
        if (idx == 2) {
            item.image = [midImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.selectedImage = [midImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0);
        }
    }];
    self.tabBar.tintColor = [UIColor colorWithRed:255.0/255 green:225/255.0 blue:17/255.0 alpha:1.0];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [tabBar.items indexOfObject:item];
    if (index == 2) {
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        self.backgroundview = blurView;
        [blurView setFrame:self.view.frame];
        [self.view addSubview:blurView];
        [self showMenus];
    }
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSArray * controllers = self.viewControllers;
    NSInteger index = [controllers indexOfObject:viewController];
    if (index == 2) {
        return NO;
    }
    return true;
}
-(void)showMenus{
    //动画

    //菜单动画
    NSArray * imagesNameArray = @[@"image1",@"image2",@"image3",@"image4",@"image5",@"image6"];
    NSArray * labelsArray = @[@"收藏",@"天气",@"吃药提醒",@"夜间模式",@"关于我们",@""];
    CGFloat width = self.view.frame.size.width;
    CGFloat itemWidth = width/3;
    self.menuviewsArray = [NSMutableArray new];
    for (int index  = 0;index < 6;index ++) {
        NSTimeInterval delay = 0.03 * index;
        CGFloat centerx;
        CGFloat centery;
        //第一排
        if (index < 3) {
            centerx = width /6 * (2*index + 1);
            centery = self.view.frame.size.height - itemWidth - itemWidth - itemWidth/2 - 49;
        }else{
            centerx = width/6 * (2 *(index - 2) -1);
            centery = self.view.frame.size.height - itemWidth - itemWidth/2 - 49;
        }
        
        UIImage * image  = [UIImage imageNamed:imagesNameArray[index]];
        NSString * title = labelsArray[index];
        UIView * containview = [self createOneMenuViewWithImage:image Title:title];
        containview.center = CGPointMake(centerx, self.view.frame.size.height);
        UITapGestureRecognizer * menuTab = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(catchMenuTap:)];
        [containview addGestureRecognizer:menuTab];
        [self.view addSubview:containview];
        [self.menuviewsArray addObject:containview];
        containview.tag = index;
    [UIView animateWithDuration:0.15
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         containview.center = CGPointMake(centerx, centery - 20);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.05
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              containview.center = CGPointMake(centerx, centery);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    }
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIImageView * closeImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
    [bottomView addSubview:closeImageview];
    closeImageview.image = [UIImage imageNamed:@"mid"];
    closeImageview.center = CGPointMake(CGRectGetWidth(bottomView.bounds)/2, CGRectGetHeight(bottomView.bounds)/2);
    self.closeImageview = closeImageview;
    //添加手势
    UITapGestureRecognizer * closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenus)];
    closeImageview.userInteractionEnabled = true;
    [closeImageview addGestureRecognizer:closeTap];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    [UIView animateWithDuration:0.4
                     animations:^{
                         closeImageview.transform = CGAffineTransformMakeRotation(M_PI/4);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
-(void)hideMenus{
    //隐藏菜单栏
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.closeImageview.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [self.bottomView removeFromSuperview];
                         [self.backgroundview removeFromSuperview];
                     }];
    for (NSInteger index = 5; index >= 0; index--) {
        UIView * containview = self.menuviewsArray[index];
        CGFloat  dealy = (5 - index)*0.03;
        [UIView animateWithDuration:0.2
                              delay:dealy
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             containview.center = CGPointMake(containview.center.x, self.view.frame.size.height + CGRectGetWidth(containview.frame)/2);
                         }
                         completion:^(BOOL finished) {
                             [containview removeFromSuperview];
                         }];
    }
    self.menuviewsArray = nil;
}

-(UIView *)createOneMenuViewWithImage:(UIImage *)image Title:(NSString *)title{
    CGFloat width = self.view.frame.size.width;
    CGFloat itemWidth = width/3;
    UIView * containview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
    UIImageView * iconImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,itemWidth-40, itemWidth-40)];
    
    iconImageview.center = CGPointMake(itemWidth/2, itemWidth/2);
    iconImageview.contentMode = UIViewContentModeScaleAspectFill;
    iconImageview.image = image;
    [containview addSubview:iconImageview];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,itemWidth-20,itemWidth, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [containview addSubview:label];
    
    return containview;
}
-(void)catchMenuTap:(UITapGestureRecognizer *)tap{
    NSLog(@"Catch tap:%ld",(long)tap.view.tag);
    
    if (tap.view.tag == 0) {
//        收藏
        collectionTableViewController *collection = [collectionTableViewController new];
        
        [self showViewController:collection sender:nil];
        
        
        
    }
    
    if (tap.view.tag == 1) {
//        天气
        WeatherViewController *weather =[WeatherViewController new];
        [self showViewController:weather sender:nil];
      
    }
    if (tap.view.tag == 2) {
//        吃药提醒
        SetAlertViewController *setAlert = [SetAlertViewController new];
        
        [self showViewController:setAlert sender:nil];
        
    }
    
    if (tap.view.tag == 3) {
        
//        夜间模式

        
        
    }
    
    
    if (tap.view.tag == 4) {
        
        
        FeedbackViewController *feedback = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
        [self showViewController:feedback sender:nil];
        
//        
    }
//    [self hideMenus];
}
@end
