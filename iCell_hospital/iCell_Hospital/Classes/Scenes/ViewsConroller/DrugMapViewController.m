//
//  DrugMapViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/12.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "DrugMapViewController.h"

@interface DrugMapViewController ()<UIWebViewDelegate>

@end

@implementation DrugMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.111.com.cn"]]];
    webView.delegate = self;
    
    self.view = webView;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('index_mask')[0].style.display = 'none'"];
    
    
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
