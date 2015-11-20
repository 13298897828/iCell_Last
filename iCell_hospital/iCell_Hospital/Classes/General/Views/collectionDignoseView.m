//
//  collectionDignoseView.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/20.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "collectionDignoseView.h"

@interface collectionDignoseView ()


@property (weak, nonatomic) IBOutlet UIImageView *imgLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;


@end

@implementation collectionDignoseView

-(void)setSickness:(Diagnose_Sickness *)sickness{
    
    _nameLabel.text = sickness.name;
    _firstLabel.text = sickness.desc;
    
    NSString *cause = [self filterHTML:sickness.causetext];
    NSString *detail = [self filterHTML:sickness.detailtext];
    _secondLabel.text = cause;
    _thirdLabel.text = detail;
    _fourthLabel.text = sickness.drug;

    [_imgLabel sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kSicknessImgUrl,sickness.img]]];

    
    
    
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


- (void)viewDidLoad {
    [super viewDidLoad];

    
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        
        
        //        self.contantView.normalBackgroundColor = [UIColor whiteColor];
        //        self.contantView.nightBackgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:.7];
        self.view.normalBackgroundColor = [UIColor clearColor];
        self.view.nightBackgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:.3];
//        self.view.userInteractionEnabled = NO;
        
        
    }];
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
