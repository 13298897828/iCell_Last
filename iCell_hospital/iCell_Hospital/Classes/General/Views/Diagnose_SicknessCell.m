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
    NSLog(@"%@", sickness.name);
    _sickness = sickness;
    
    NSString *cause = [self filterHTML:sickness.causetext];
    NSString *detail = [self filterHTML:sickness.detailtext];

    _nameLabel.text = sickness.name;
    _descLabel.text = sickness.desc;
    _causeLabel.text = cause;
    _detailLabel.text = detail;
    _drugLabel.text = sickness.drug;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSicknessImgUrl,sickness.img]]];
    
//    self.del();

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
    
    [_collectionButton setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateNormal];
    
    [self showAnimation];
    
    [[DBManager sharedManager] insertSickness:_sickness];
    NSLog(@"%@ %@",_sickness.name,_sickness.causetext);
}

//收藏动画
- (void)showAnimation {
    
    //the image which will play the animation soon
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yishoucang"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.hidden = YES;
    imageView.center = CGPointMake(self.frame.size.width-20, 100);
    
    //the container of image view
    CALayer *layer = [[CALayer alloc]init];
    layer.contents = imageView.layer.contents;
    layer.frame = imageView.frame;
    layer.opacity = 1;
    [self.layer addSublayer:layer];
    
    //动画 终点 都以sel.view为参考系
    CGPoint endpoint = CGPointMake(self.frame.size.width*0.5, self.frame.size.height);
    
    //动画起点
    CGPoint startPoint = CGPointMake(self.bounds.size.width-50, 60);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    //贝塞尔曲线控制点
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endpoint.x;
    float ey = endpoint.y;
    float x = sx + (ex - sx) / 3 ;
    float y = sy + (ey - sy) * 0.5 - 400;
    CGPoint centerPoint=CGPointMake(x, y);
    
    
    //    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    [path addCurveToPoint:CGPointMake(300,340) controlPoint1:CGPointMake(100, 300) controlPoint2:CGPointMake(229, 280)];
    
    [path moveToPoint:CGPointMake(300, 340)];
    
    [path addCurveToPoint:CGPointMake(self.frame.size.width*0.5,self.frame.size.height) controlPoint1:CGPointMake(230, 360) controlPoint2:CGPointMake(250, 340)];
    
    //key frame animation to show the bezier path animation
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 1.5;
    animation.delegate = self;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:@"buy"];
}

//xib会走此方法
- (void)awakeFromNib {

    self.searchBar.delegate = self;
    
 
} 




    // 使得点击本身后不会变色
    self.selectedBackgroundView = ({
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:183/255. green:213/255. blue:233/255. alpha:0.8];
        view;
        
    });

}
 




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
