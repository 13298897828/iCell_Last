//
//  HospitalDetailViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalDetailViewController.h"


@interface HospitalDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_message;
    NSString *_feature;
}
@property (strong, nonatomic) IBOutlet UIImageView *hosImageView;
@property (strong, nonatomic) IBOutlet UILabel *hosNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *hosLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *hosMtype;
@property (strong, nonatomic) IBOutlet UILabel *hosAddressLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *favouritButton;

@property(nonatomic,strong)UILabel *messageLabel;

@end

@implementation HospitalDetailViewController
static NSString *const cellID = @"CellID";

+ (instancetype)sharedHospitalDetalVC{
    static HospitalDetailViewController *hospitalDetailVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hospitalDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HospitalDetailViewController"];
    });
    return hospitalDetailVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationController.hidesBarsOnSwipe = NO;
[self.segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.segmentControl.selectedSegmentIndex = 0;
    
    self.hosAddressLabel.text = self.hospital.address;
    NSString *imgURl = [@"http://tnfs.tngou.net/img" stringByAppendingString:_hospital.img];
    [self.hosImageView sd_setImageWithURL:[NSURL URLWithString:imgURl]];
    self.hosNameLabel.text = self.hospital.name;
    self.hosLevelLabel.text = self.hospital.level;
    self.hosMtype.text = self.hospital.mtype;
    self.messageLabel.text = @"";

    [[DBManager sharedManager] openDB];
    self.hospital.isFavourit=[[DBManager sharedManager] findHospitalInDataBase:self.hospital];
    if (self.hospital.isFavourit) {
        [self.favouritButton setImage:[UIImage imageNamed:@"yishoucang"]];
    }else{
        [self.favouritButton setImage:[UIImage imageNamed:@"shoucang"]];
    }
    [[DBManager sharedManager] closeDB];
    
    [self segmentControlAction:self.segmentControl];
    
}

#pragma mark tableView 协议
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    if (cell.contentView.subviews.count>1) {
        [cell.contentView.subviews[1] removeFromSuperview];
    }
    
    self.messageLabel.text = _message;
    self.messageLabel.numberOfLines = 0;
 CGFloat height = [self calcHeightWithlabel:self.messageLabel];
    self.messageLabel.frame = CGRectMake(8, 0, self.view.bounds.size.width-16, height);
    [cell.contentView addSubview:self.messageLabel];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//计算cell高度
- (CGFloat)calcHeightWithlabel:(UILabel *)label{
    
    CGSize maxSize=CGSizeMake(label.frame.size.width, 1500);
    
    NSDictionary *dict=@{
                         NSFontAttributeName:label.font
                         };
    
    CGRect frame=[_message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.messageLabel.frame.size.height;
}

//在地图中显示医院位置
- (IBAction)showInMapAction:(UIButton *)sender {
    HospitalMapViewController *hosMapVC=[HospitalMapViewController new];
    hosMapVC.hospital = self.hospital;
    [self.navigationController pushViewController:hosMapVC animated:YES];
   
}
//收藏键的方法
- (IBAction)favouriteAction:(UIBarButtonItem *)sender {
    
    if (self.hospital.isFavourit) {
        self.hospital.isFavourit = NO;
    [sender setImage: [UIImage imageNamed:@"shoucang"]];
    }else{
        self.hospital.isFavourit = YES;
        [sender setImage: [UIImage imageNamed:@"yishoucang"]];
         [self showAnimation];
    }
    [[DBManager sharedManager] insertHospital:self.hospital];

//   取得数据库中的所有模型 ,实时更新数据库中的存储模型的数组
    [[DBManager sharedManager] findAllHospitalInDataBase];
    
    
}


//收藏动画
- (void)showAnimation {

    //the image which will play the animation soon
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yishoucang"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.hidden = YES;
    imageView.center = CGPointMake(self.view.frame.size.width-20, 100);
    
    //the container of image view
    CALayer *layer = [[CALayer alloc]init];
    layer.contents = imageView.layer.contents;
    layer.frame = imageView.frame;
    layer.opacity = 1;
    [self.view.layer addSublayer:layer];
    



    //动画起点
    CGPoint startPoint = CGPointMake(self.view.bounds.size.width-50, 60);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    //贝塞尔曲线控制点

   
//动画 终点 都以sel.view为参考系
//    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    [path addCurveToPoint:CGPointMake(self.view.frame.size.width-10,360) controlPoint1:CGPointMake(100, 300) controlPoint2:CGPointMake(229, 280)];
    
    [path moveToPoint:CGPointMake(self.view.frame.size.width-10, 360)];

    [path addCurveToPoint:CGPointMake(self.view.frame.size.width*0.5,self.view.frame.size.height) controlPoint1:CGPointMake(230, 360) controlPoint2:CGPointMake(250, 340)];
    
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






//请求医院简介数据
- (void)requestData{
    
     NSString *httArg = [NSString stringWithFormat:@"id=%@",self.hospital._id];

    [[HospitalHelper sharedHospitalHelper] requestHttpUrl:kDetailMessageUrl withHttpArg:httArg success:^(id data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (![dic[@"message"] isEqualToString:@""]) {
            _feature = dic[@"gobus"];
           _message = dic[@"message"];
        }else{
            _message = @"暂无简介";
        }
        
        
       _message = [_message stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        if ([_message rangeOfString:@"<strong>"].location !=NSNotFound ) {
        NSRange range1 = [_message rangeOfString:@"<strong>"];
        NSInteger location = range1.location;
        NSRange range2 = [_message rangeOfString:@"</strong>"];
        NSInteger location2 = range2.location;
        NSInteger length = location2 -location;
        NSRange range = NSMakeRange(location, length);
        _message = [_message stringByReplacingCharactersInRange:range withString:@""];
        }
       
        _message = [self filterHTML:_message];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        });
    }];
}

//去除html标签
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
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@"   "];
    }
    return html;
    
}

//切换所看内容
- (void)segmentControlAction:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex == 1) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
        [self requestFeatureData];
    });
    }
    if(sender.selectedSegmentIndex ==  0){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self requestData];
        });
    }
    if (sender.selectedSegmentIndex == 2) {

        if ([_feature isEqualToString:@"<p> </p>"]|| !_feature  ) {
            _message = @"未查找到乘车路线";
        }else{
            _feature = [self filterHTML:_feature];
            _message = _feature;
        }
        
        [self.tableView reloadData];
    }

    
}

// 请求医院特色诊室
- (void)requestFeatureData{
    NSString *httArg = [NSString stringWithFormat:@"id=%@",self.hospital._id];
    [[HospitalHelper sharedHospitalHelper] requestHttpUrl:kFeaturehttpUrl withHttpArg:httArg success:^(id data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (array.count) {
             NSDictionary *dic = array[0];
            _message =[@"科室:" stringByAppendingString: [dic[@"name"] stringByAppendingFormat:@"\n%@",dic[@"message"]]];
            if (array.count>1) {
                NSDictionary *dic2 = array[1];
                _message =[_message stringByAppendingString:[NSString stringWithFormat:@"\n科室：%@\n%@",dic2[@"name"],dic2[@"message"]]];
            }
            
        }else{
            _message = @"暂无相关内容";
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    _feature = @"<p> </p>";
    _message = @"";
}

@end
