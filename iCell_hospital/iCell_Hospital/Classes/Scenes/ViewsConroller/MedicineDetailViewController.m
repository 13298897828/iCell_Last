//
//  MedicineDetailViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/10.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "MedicineDetailViewController.h"

@interface MedicineDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIScrollView *DetailScrollView;
@property (weak, nonatomic) IBOutlet UIView *contantView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *introduceLabel1;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel2;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel3;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel4;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel5;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel6;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel7;
@property (weak, nonatomic) IBOutlet UIButton *collectionMedicineButton;

@end

@implementation MedicineDetailViewController
-(void)setMedicine:(Medicine *)medicine{
    
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:medicine.img]];
    
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
//    NSLog(@"%@,%@,%d",medicine.name,medicine.messageArray[2],medicine.price);
 
    _medicine = medicine;
    _nameLabel.text = medicine.name;
    _typeLabel.text = medicine.type;
    _priceLabel.text = [NSString stringWithFormat:@"%d",medicine.price];
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

    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 200, 80, 80);
    //    [button setTitle:@"哇哈哈" forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:@"fu"] forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    button.tintColor = [UIColor whiteColor];
    
    [button addTarget:self action:@selector(jumpToConsulting) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:view];
    
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
  
  
//        self.contantView.normalBackgroundColor = [UIColor whiteColor];
//        self.contantView.nightBackgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:.7];
         view.normalBackgroundColor = [UIColor clearColor];
         view.nightBackgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:.3];
        view.userInteractionEnabled = NO;

 
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
