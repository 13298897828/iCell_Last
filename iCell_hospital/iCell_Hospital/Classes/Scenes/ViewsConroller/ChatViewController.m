//
//  ChatViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/17.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()
@property (nonatomic,strong)NSString *token;
@end

@implementation ChatViewController
 
- (void)viewDidLoad {
        [super viewDidLoad];
//    RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc] init];
    self.conversationType = ConversationType_APPSERVICE;
    self.targetId = @"KEFU144764309259741";
    //    [UIDevice currentDevice].model
    self.userName = @"您";
    self.title = @"您";
    NSUUID *str = [UIDevice currentDevice].identifierForVendor;
    NSString *str1 = str.UUIDString;
    NSString *string = [NSString stringWithFormat:@"http://101.200.242.10/rctest/test2.php?id=%@&user=xiaohao",str1];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
          {
              if (!data) {
                  NSLog(@"错误");
                  return ;
              }
              
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
              
              
              _token = dict[@"token"];
              
                        NSLog(@"%@",_token);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  
                  [[RCIM sharedRCIM] connectWithToken:_token success:^(NSString *userId) {
                      // Connect 成功
                      NSLog(@"链接成功");
                  }
                                                error:^(RCConnectErrorCode status) {
                                                    // Connect 失败
                                                    NSLog(@"链接失败");
                                                }
                                       tokenIncorrect:^() {
                                           // Token 失效的状态处理
                                           
                    }];
                  
              });
              
          }];
    [task resume];

    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
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
