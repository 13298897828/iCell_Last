//
//  DiagnoseManager.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "DiagnoseManager.h"

@interface DiagnoseManager ()

//疾病资讯数组
@property(nonatomic,strong)NSMutableArray *allDataArray;
//所有检查项目数组
@property(nonatomic,strong)NSMutableArray *checkArr;
//手术项目
@property(nonatomic,strong)NSMutableArray *operationArr;

@end

@implementation DiagnoseManager

+ (instancetype)sharedDiagnoseManager{
    static DiagnoseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DiagnoseManager new];
    });
    return manager;
}

#pragma mark - 初始化方法中请求数据
- (instancetype)init{
    if (self = [super init]) {
        //疾病资讯
        [self requstAllData];
        
        //检查项目
        for (int i = 0; i < 50; i ++) {
            
            NSString *httpUrl = @"http://apis.baidu.com/tngou/check/show";
            NSString *httpArg = [NSString stringWithFormat:@"id=%d",i];
            [self request: httpUrl withHttpArg: httpArg];
        }
        
        //手术项目
        for (int i = 0; i < 50; i ++) {
            
            NSString *httpUrl = @"http://apis.baidu.com/tngou/operation/show";
            NSString *httpArg = [NSString stringWithFormat:@"id=%d",i];
            [self requestOperation: httpUrl withHttpArg: httpArg];
        }
        
    }
    
    return self;
}


#pragma mark - 疾病资讯请求数据
- (void)requstAllData{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                {
        NSString *typeString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)@"健康",NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kDiagnoseUrl,typeString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        //解析数据
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse *  _Nullable response, NSError * _Nullable error) {

            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = dict[@"tngou"];
            
            for (int i = 6; i < 14; i ++) {
                Diagnose_Info *digInfo = [Diagnose_Info new];
                [digInfo setValuesForKeysWithDictionary:arr[i]];
                if (![digInfo.tit isEqualToString:@
                      ""]) {
                    [self.allDataArray addObject:digInfo];
                }
            }
            
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                self.digResult();
                self.digResult1();
            });
        }];
    
        //执行
        [task resume];
    });
}

#pragma mark - 检查项目请求数据
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
            if (item.name != nil) {
                
                [self.checkArr addObject:item];
                
            }
        }
        
    }];
}

#pragma mark - 手术项目请求数据
-(void)requestOperation: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
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
            
            Diagnose_Operation *opr = [Diagnose_Operation new];
            [opr setValuesForKeysWithDictionary:dic];
            if (opr.name != nil) {
                
                [self.operationArr addObject:opr];
                
            }
        }
        
    }];
}

#pragma mark - 懒加载
//疾病资讯
- (NSMutableArray *)allDataArray{
    if (!_allDataArray) {
        self.allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (NSArray *)infoArr{
    return [self.allDataArray copy];
}


//检查项目
- (NSMutableArray *)checkArr{
    if (!_checkArr) {
        self.checkArr = [NSMutableArray array];
    }
    return _checkArr;
}
- (NSArray *)itemArr{
    return [self.checkArr copy];
}

//手术项目
- (NSMutableArray *)operationArr{
    if (!_operationArr) {
        self.operationArr = [NSMutableArray array];
    }
    return _operationArr;
}
- (NSArray *)operateArr{
    return [self.operationArr copy];
}



@end


















