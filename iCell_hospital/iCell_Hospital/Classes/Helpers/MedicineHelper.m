//
//  MedicineHelper.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "MedicineHelper.h"

@interface MedicineHelper ()



@end
@implementation MedicineHelper



+(instancetype)sharedManager{
    
    static MedicineHelper *medicineHelper;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        medicineHelper = [MedicineHelper new];
        
    });
    
    return medicineHelper;
}

-(instancetype)init{
    
    if (self = [super init]) {
        //    [self request: httpUrl withHttpArg: httpArg];
    }
    
    return self;
}

-(void)request:(NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    
    
    [_MedicineArray removeAllObjects];
    //子线程解析数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        [request setHTTPMethod: @"GET"];
        [request addValue: @"c3755e88decce5a63cfe9aae49cf7e0b" forHTTPHeaderField: @"apikey"];
        [NSURLConnection sendAsynchronousRequest: request
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                   } else {
                                       
                                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                                       
                                       for (NSDictionary *dic in dict[@"tngou"]) {
                                           
                                           Medicine *medicine = [Medicine new];
                                           [medicine setValuesForKeysWithDictionary:dic];
                                           //              分离 成行
                                           NSMutableArray *array = [medicine.message componentsSeparatedByString:@"【"];
                                           [array removeObjectAtIndex:0];
                                    
                                           for (NSString *itemStr in array) {
                                               NSString* itemStr1 = [@"【" stringByAppendingString:itemStr];
                                               
                                               [medicine.messageArray addObject:itemStr1];
                                               
//                                               NSLog(@"%@",medicine.messageArray[0]);
                                               
                                           }
                                           [_MedicineArray addObject:medicine];
                                           
                                       }
                                       
                                   }
                                   
                                   //       主线程刷新
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       if (![HospitalHelper isExistenceNetwork]) {
                                           return ;
                                       }else{
                                       
                                       self.result();
                                       }
                                       
                                   });
                               }];
        
        
        
    });
    
}

-(void)requestMedicineWithCode: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg {
   Medicine *medicine = [Medicine new];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        

    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"c3755e88decce5a63cfe9aae49cf7e0b" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                   NSLog(@"%ld %@",responseCode,responseString);
                                   
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                                   

                                       [medicine setValuesForKeysWithDictionary:dict];
                                       //              分离 成行
                                       NSMutableArray *array = [medicine.message componentsSeparatedByString:@"【"];
                                       [array removeObjectAtIndex:0];
                                       
                                       for (NSString *itemStr in array) {
                                           NSString* itemStr1 = [@"【" stringByAppendingString:itemStr];
                                          
                                           NSString *a =  [self filterHTML:itemStr1];
                                           [medicine.messageArray addObject:a];
                                           
                                       }
                               
                                       
                                   }
                               
                               NSDictionary *dic = [NSDictionary new];
                               [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"user"];
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                     medicine.img = [NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",medicine.img];
                                   self.medicine = medicine;
                                   self.result1();

                               });

                           }];
    
    });

}

- (NSString *)filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    html = [_message stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    //            NSString * regEx = @"<([^>]*)>";
    //            html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
    
}
-(Medicine *)medicine{
    
    if (!_medicine) {
        
        self.medicine = [Medicine new];
        
    }
    
    return _medicine;
    
}

-(NSMutableArray *)MedicineArray{
    
    if (!_MedicineArray) {
        
        self.MedicineArray = [NSMutableArray new];
        
    }
    
    return _MedicineArray;
    
}

-(NSArray *)MedicineInfoArray{
    
    _MedicineInfoArray = [self.MedicineArray copy];
    
//    NSLog(@"%ld,%ld",_MedicineInfoArray.count,_MedicineArray.count);
    
 
    
    return  _MedicineInfoArray;
    
}

@end
