//
//  Diagnose_SicknessCell.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/11.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_SicknessCell.h"

@interface Diagnose_SicknessCell ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

@end

@implementation Diagnose_SicknessCell

- (void)setSickness:(Diagnose_Sickness *)sickness{
    
    NSString *cause = [self filterHTML:sickness.causetext];
    NSString *detail = [self filterHTML:sickness.detailtext];

    _nameLabel.text = sickness.name;
    _descLabel.text = sickness.desc;
    _causeLabel.text = cause;
    _detailLabel.text = detail;
    _drugLabel.text = sickness.drug;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSicknessImgUrl,sickness.img]]];
    
    self.del();

}


#pragma searchbar的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    NSString *httpUrl = @"http://apis.baidu.com/tngou/symptom/name";
    NSString *typeString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)self.searchBar.text,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    NSString *httpArg = [NSString stringWithFormat:@"name=%@",typeString];
    [self request: httpUrl withHttpArg: httpArg];
    
    [_searchBar endEditing:YES];
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
            Diagnose_Sickness *sick = [Diagnose_Sickness new];
            [sick setValuesForKeysWithDictionary:dic];
            self.sickness = sick;
        }
        
    }];
}

//消除解析出的数据的HTML标记
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

    return html;
}

- (IBAction)collectionAction:(UIButton *)sender {
    
    
    
}





//xib会走此方法
- (void)awakeFromNib {

    self.searchBar.delegate = self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
