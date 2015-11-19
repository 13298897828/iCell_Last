//
//  Diagnose_CheckItemViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_CheckItemViewController.h"

@interface Diagnose_CheckItemViewController ()

@property(nonatomic,strong)Diagnose_CheckItemCell *cell;

@end

@implementation Diagnose_CheckItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设定cell根据内容自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    
    NSString *httpUrl = @"http://apis.baidu.com/tngou/check/name";
    NSString *typeString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)@"CT检查",NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    NSString *httpArg = [NSString stringWithFormat:@"name=%@",typeString];
    [self request: httpUrl withHttpArg: httpArg];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"Diagnose_CheckItemCell" bundle:nil] forCellReuseIdentifier:@"checkItemCellId"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:@"checkItemCellId" forIndexPath:indexPath];
    
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
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            Diagnose_CheckItem *item = [Diagnose_CheckItem new];
            [item setValuesForKeysWithDictionary:dic];
            _cell.item = item;
        }
        
    }];
}


//设置cell的出现动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.layer.transform = CATransform3DMakeScale(1.0, 0, 1);
    [UIView animateWithDuration:.5 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
