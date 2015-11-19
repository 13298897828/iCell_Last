//
//  Diagnose_OperationViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/14.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_OperationViewController.h"

@interface Diagnose_OperationViewController ()

@property(nonatomic,strong)Diagnose_OperationCell *cell;

@end

@implementation Diagnose_OperationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设定cell根据内容自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    NSString *typeString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)@"心脏搭桥手术",NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    NSString *httpUrl = @"http://apis.baidu.com/tngou/operation/name";
    NSString *httpArg = [NSString stringWithFormat:@"name=%@",typeString];
    [self request: httpUrl withHttpArg: httpArg];
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"Diagnose_OperationCell" bundle:nil] forCellReuseIdentifier:@"operateCellId"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:@"operateCellId" forIndexPath:indexPath];
    
    _cell.initData = ^(){
        [tableView reloadData];
    };
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell.table.hidden = YES;
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlString = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"3d3dfb25a74f419547bfef42d666d2b6" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
            if (error) {
                NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
            } else {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                Diagnose_Operation *ope = [Diagnose_Operation new];
                [ope setValuesForKeysWithDictionary:dict];
                _cell.oper = ope;
            }
    }];
}


//设置cell的出现动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.layer.transform = CATransform3DMakeScale(0, 1., 1);
    [UIView animateWithDuration:.5 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
