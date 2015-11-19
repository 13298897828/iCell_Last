//
//  Diagnose_FoodCell.m
//  iCell_Hospital
//
//  Created by 王颜华 on 15/11/14.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "Diagnose_FoodCell.h"

@interface Diagnose_FoodCell ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;


@property(nonatomic,strong)UIImageView *imView;

@end


@implementation Diagnose_FoodCell

- (void)setFood:(Diagnose_Food *)food{
    //去除HTML标记符号
    NSString *mss = [self filterHTML:food.message];
    NSString *sum = [self filterHTML:food.summary];
    
    _nameLabel.text = food.name;
    _summaryLabel.text = sum;
    _messageLabel.text = mss;
    _descriptLabel.text = food.desc;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSicknessImgUrl,food.img]]];
    
    self.initData();
}

#pragma searchbar的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *httpUrl = @"http://apis.baidu.com/tngou/food/name";
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
            Diagnose_Food *food = [Diagnose_Food new];
            [food setValuesForKeysWithDictionary:dic];
            self.food = food;
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


//xib会走此方法
- (void)awakeFromNib {
    
    self.searchBar.delegate = self;
    
    //初始化显示图片信息的imgView
    CGRect rect = CGRectMake(10, 10, self.window.frame.size.width - 20, self.window.frame.size.height - 20);
    self.imView = [[UIImageView alloc] init];
    self.imView.frame = rect;
    _imView.contentMode = UIViewContentModeScaleAspectFit;
    [_imView sd_setImageWithURL:[NSURL URLWithString:_food.img]];
    
    [self.window addSubview:_imView];
    //打开imView的用户交互
    _imView.userInteractionEnabled = YES;
    _imgView.userInteractionEnabled = YES;
    
    //先把它放到window的最后面
    [self.window sendSubviewToBack:_imView];
    
    //给图片添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_imgView addGestureRecognizer:tap];
}
- (void)tapAction{
    //把放大的图片提到前面
    [self.window bringSubviewToFront:_imView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackAction)];
    [_imView addGestureRecognizer:tap];
}
- (void)tapBackAction{
    [self.window bringSubviewToFront:_imView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
