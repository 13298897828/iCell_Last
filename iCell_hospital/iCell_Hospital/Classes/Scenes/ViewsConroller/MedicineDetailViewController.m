//
//  MedicineDetailViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/10.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "MedicineDetailViewController.h"
#import "nilViewController.h"
#import <UIImage+GIF.h>
#import "AFNetworkingManager.h"

@interface MedicineDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIScrollView *DetailScrollView;
@property (weak, nonatomic) IBOutlet UIView *contantView;

@property (strong, nonatomic) IBOutlet UILabel *yaoPinMingChengLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *yaoPinLeiXingLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (strong, nonatomic) IBOutlet UILabel *yaoPinJiaGe;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UIButton *fanHuiButton;

@property (weak, nonatomic) IBOutlet UILabel *introduceLabel1;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel3;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel4;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel5;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel6;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel7;
@property (weak, nonatomic) IBOutlet UIButton *collectionMedicineButton;
@property (nonatomic,strong)UIButton *talkButton;

@end

@implementation MedicineDetailViewController
-(void)setMedicine:(Medicine *)medicine{
    
    
    if (![HospitalHelper isExistenceNetwork]) {
        
     
        return;
        
    }
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:medicine.img]];
    
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
//    NSLog(@"%@,%@,%d",medicine.name,medicine.messageArray[2],medicine.price);
 
    _medicine = medicine;
    _nameLabel.text = medicine.name;
    _typeLabel.text = medicine.type;
    _priceLabel.text = [NSString stringWithFormat:@"%d",medicine.price];
    NSLog(@"%ld",medicine.messageArray.count);
    if (medicine.messageArray.count == 0) {
        

        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y + 180, self.view.frame.size.width, 35)];

        label.textColor = [UIColor colorWithRed:0.102 green:0.000 blue:0.000 alpha:1.000];
        label.font = [UIFont systemFontOfSize:22];
        label.textAlignment = 1;
        label.text = @"没有这种药品的信息...";

//        imgView.image = [UIImage imageNamed:@"meiwang.gif"];
        UIImage *image = [UIImage sd_animatedGIFNamed:@"meiwang"];
        imgView.image = image;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80)];
        imgView.center = view.center;
        
        [view addSubview:imgView];
        [view addSubview:label];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        _talkButton.hidden = YES;
        _collectionMedicineButton.hidden = YES;
        
        return;
    }
    _introduceLabel1.text = medicine.messageArray[1];
    _introduceLabel2.text = medicine.messageArray[2];
    _introduceLabel3.text = medicine.messageArray[3];
    _introduceLabel4.text = medicine.messageArray[4];
    _introduceLabel5.text = medicine.messageArray[5];
    _introduceLabel6.text = medicine.messageArray[6];
    _introduceLabel7.text = medicine.messageArray[7];
    
}
 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _talkButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _talkButton.frame = CGRectMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 200, 80, 80);
    //    [button setTitle:@"哇哈哈" forState:(UIControlStateNormal)];
    [_talkButton setImage:[UIImage imageNamed:@"fu"] forState:(UIControlStateNormal)];
    [self.view addSubview:_talkButton];
    [self.view bringSubviewToFront:_talkButton];
    _talkButton.tintColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    
    [_talkButton addTarget:self action:@selector(jumpToConsulting) forControlEvents:(UIControlEventTouchUpInside)];
    
    _talkButton.tintColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000];
    
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
//        self.contantView.normalBackgroundColor = [UIColor whiteColor];
//        self.contantView.nightBackgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:.7];
//         view.normalBackgroundColor = [UIColor clearColor];
//         view.nightBackgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:0.177];
        self.DetailScrollView.subviews[0].nightBackgroundColor = UIColorFromRGB(0x343434);
        self.DetailScrollView.subviews[0].normalBackgroundColor = [UIColor whiteColor];
        
        self.yaoPinMingChengLabel.nightBackgroundColor = UIColorFromRGB(0x343434);
        self.yaoPinMingChengLabel.normalBackgroundColor = [UIColor whiteColor];
        self.yaoPinMingChengLabel.normalTextColor  = [UIColor blackColor];
        self.yaoPinMingChengLabel.nightTextColor = [UIColor lightTextColor];
        
        self.nameLabel.nightBackgroundColor = UIColorFromRGB(0x343434);
        self.nameLabel.normalBackgroundColor = [UIColor whiteColor];
        self.nameLabel.normalTextColor  = [UIColor blackColor];
        self.nameLabel.nightTextColor = [UIColor lightTextColor];
        
        self.yaoPinLeiXingLabel.nightBackgroundColor = UIColorFromRGB(0x343434);
        self.yaoPinLeiXingLabel.normalBackgroundColor = [UIColor whiteColor];
        self.yaoPinLeiXingLabel.normalTextColor  = [UIColor blackColor];
        self.yaoPinLeiXingLabel.nightTextColor = [UIColor lightTextColor];
        
        self.typeLabel.nightBackgroundColor = UIColorFromRGB(0x343434);
        self.typeLabel.normalBackgroundColor = [UIColor whiteColor];
        self.typeLabel.normalTextColor  = [UIColor blackColor];
        self.typeLabel.nightTextColor = [UIColor lightTextColor];
        
        self.yaoPinJiaGe.nightBackgroundColor = UIColorFromRGB(0x343434);
        self.yaoPinJiaGe.normalBackgroundColor = [UIColor whiteColor];
        self.yaoPinJiaGe.normalTextColor  = [UIColor blackColor];
        self.yaoPinJiaGe.nightTextColor = [UIColor lightTextColor];
        
        self.priceLabel.nightBackgroundColor = UIColorFromRGB(0x343434);
        self.priceLabel.normalBackgroundColor = [UIColor whiteColor];
        self.priceLabel.normalTextColor  = [UIColor blackColor];
        self.priceLabel.nightTextColor = [UIColor lightTextColor];
        
        for (UIView *label in self.DetailScrollView.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
            label.nightBackgroundColor = UIColorFromRGB(0x343434);
            label.normalBackgroundColor = [UIColor whiteColor];
            ((UILabel *)label).normalTextColor  = [UIColor blackColor];
            ((UILabel *)label).nightTextColor = [UIColor lightTextColor];
            }
 
        }

        
    }];
    
}
#pragma mark -跳转客服界面
-(void)jumpToConsulting{
    
    ChatViewController *chat = [ChatViewController new];
    
    
    // 快速集成第二步，连接融云服务器
    self.hidesBottomBarWhenPushed = YES;
    [self showViewController:chat sender:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    
    
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)collectionMedicineButton:(UIButton *)sender {
    

    
    if (_medicine.flag) {
        
        [[DBManager sharedManager] deleteMedicineWithId:_medicine];
        _medicine.flag = !_medicine.flag;
       [_collectionMedicineButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];

    }else{
        [[DBManager sharedManager] insertMedicine:_medicine];
        _medicine.flag = !_medicine.flag;
               [_collectionMedicineButton setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateNormal];
        [self showAnimation];

    }
 
    
    
}

//收藏动画
- (void)showAnimation {
    //get the location of label
    CGPoint lbCenter = CGPointMake(self.view.frame.size.width - 45, 35);
    //the image which will play the animation soon
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yishoucang"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.hidden = YES;
    imageView.center = lbCenter;
    
    //the container of image view
    CALayer *layer = [[CALayer alloc]init];
    layer.contents = imageView.layer.contents;
    layer.frame = imageView.frame;
    layer.opacity = 1;
    [self.view.layer addSublayer:layer];
    
    //动画 终点 都以sel.view为参考系
    CGPoint endpoint = CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height);
    UIBezierPath *path = [UIBezierPath bezierPath];
    //动画起点
    CGPoint startPoint = lbCenter;
    [path moveToPoint:startPoint];
    //贝塞尔曲线控制点
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endpoint.x;
    float ey = endpoint.y;
    float x = sx + (ex - sx) / 3 ;
    float y = sy + (ey - sy) * 0.5 - 400;
    CGPoint centerPoint=CGPointMake(x-100, y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    
    
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




-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[DBManager sharedManager] openDB];
    [[DBManager sharedManager] createMedicineTable];
    
    _medicine.flag = [[DBManager sharedManager] selectMedicineFormTable:_medicine];
    if (_medicine.flag) {
       
//        设置图标实心
        [_collectionMedicineButton setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateNormal];
        
    }else{
        
//        设置图标空心
        [_collectionMedicineButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
        
    }
    
    if (!_flag) {
        
        _talkButton.hidden = YES;
        
    }else{
        
        _talkButton.hidden = NO;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[DBManager sharedManager] closeDB];
    
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
