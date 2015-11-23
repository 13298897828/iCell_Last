//
//  SetAlertViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "SetAlertViewController.h"

@interface SetAlertViewController ()<KPTimePickerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *setTimeBtn;
- (IBAction)setTime:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic,strong) KPTimePicker *timePicker;

@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic,strong) UIPanGestureRecognizer *panRecognizer;


@end

@implementation SetAlertViewController

-(void)timePicker:(KPTimePicker *)timePicker selectedDate:(NSDate *)date{
    [self show:NO timePickerAnimated:YES];
    
    if(date){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
        self.timeLabel.text = [[dateFormatter stringFromDate:date] lowercaseString];
        NSLog(@"======%@",date);
        
        
        //将数据存入数组
        [[TimeManager sharedTimeManager].timeArr addObject:date];
        [appDelegate.appDefault setObject:[TimeManager sharedTimeManager].timeArr forKey:@"allTime"];
        
        
        NSLog(@"%@",[TimeManager sharedTimeManager].timeArr);
        
        //设置推送
        CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 8.0) {
            //8.0本地推送
            UILocalNotification *localNotifi = [[UILocalNotification alloc] init];
            //推送的发送时间
            localNotifi.fireDate = date;    //启动时间
            
            //设置时区
            localNotifi.timeZone = [NSTimeZone defaultTimeZone];
            
            
            //推送的标题
            localNotifi.alertTitle = @"吃药提醒";
            
            //推送的文本内容
            localNotifi.alertBody = @"吃药啦，吃药啦~";
            
            //推送声音
            localNotifi.soundName = UILocalNotificationDefaultSoundName;
            
            
            //设置推送的标志
            NSString *key = [[dateFormatter stringFromDate:date] lowercaseString];
            localNotifi.userInfo = @{key:date};
            
            //应用程序接受推送
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
            
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if([otherGestureRecognizer isEqual:self.panRecognizer] && !self.timePicker) return NO;
    return YES;
}

-(void)longPressRecognized:(UILongPressGestureRecognizer*)sender{
    if(sender.state == UIGestureRecognizerStateBegan){
        [self show:YES timePickerAnimated:YES];
    }
}

-(void)show:(BOOL)show timePickerAnimated:(BOOL)animated{
    if(show){
        self.timePicker.pickingDate = [NSDate date];
        [self.view addSubview:self.timePicker];
    }
    else{
        [self.timePicker removeFromSuperview];
    }

    
}

-(void)panRecognized:(UIPanGestureRecognizer*)sender{
    if(!self.timePicker) return;
    [self.timePicker forwardGesture:sender];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = color(36,40,46,1);
    
    self.setTimeBtn.layer.cornerRadius = 10;
    self.setTimeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.setTimeBtn.layer.borderWidth = 2;
    
    self.timePicker = [[KPTimePicker alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    self.timePicker.delegate = self;
    self.timePicker.minimumDate = [self.timePicker.pickingDate dateAtStartOfDay];
    self.timePicker.maximumDate = [[[self.timePicker.pickingDate dateByAddingMinutes:(60*24)] dateAtStartOfDay] dateBySubtractingMinutes:5];
    
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    self.longPressGestureRecognizer.allowableMovement = 44.0f;
    self.longPressGestureRecognizer.delegate = self;
    self.longPressGestureRecognizer.minimumPressDuration = 0.6f;
    [self.setTimeBtn addGestureRecognizer:self.longPressGestureRecognizer];
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    [self.view addGestureRecognizer:self.panRecognizer];
    
}

- (IBAction)setTime:(UIButton *)sender {
    [self show:YES timePickerAnimated:YES];
}

- (IBAction)backAction:(UIButton *)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)backAction1:(UIButton *)sender {
    
       [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    
    if (_flag) {
        
        _backButton.hidden = YES;
        
    }else {
        
        
        _backButton.hidden = NO;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
