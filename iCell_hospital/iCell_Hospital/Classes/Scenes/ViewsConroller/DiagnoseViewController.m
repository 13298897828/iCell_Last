//
//  DiagnoseViewController.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "DiagnoseViewController.h"
#import "SDCycleScrollView.h"

@interface DiagnoseViewController ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cycleView;

- (IBAction)sicknessInfoAction:(UIButton *)sender;
- (IBAction)checkAction:(UIButton *)sender;
- (IBAction)operationAction:(UIButton *)sender;
- (IBAction)healthAction:(UIButton *)sender;


//轮播图的数组（标题和图片）
@property(nonatomic,strong)NSMutableArray *titles;
@property(nonatomic,strong)NSMutableArray *imgUrls;

//轮播图的View
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;

//推出设置时间
- (IBAction)toSetTime:(UIBarButtonItem *)sender;


@end

@implementation DiagnoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数组
    self.titles = [NSMutableArray array];
    self.imgUrls = [NSMutableArray array];
    
    //实现block块
    [DiagnoseManager sharedDiagnoseManager].digResult = ^(){
        [self getAllTitleAndURLs];
    };
    
    [DiagnoseManager sharedDiagnoseManager].digResult1 = ^(){
        [self reloadViews];
    };
 
}

//获取所有的titles和imgs
- (void)getAllTitleAndURLs{
    NSArray *arr = [DiagnoseManager sharedDiagnoseManager].infoArr;
    for (Diagnose_Info *info in arr) {
        
        [self.titles addObject:info.tit];
        [self.imgUrls addObject:info.img];
    }
}

//加载视图
- (void)reloadViews{
    
    CGFloat w = self.view.bounds.size.width;
    //网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 180) imageURLStringsGroup:nil]; // 模拟网络延时情景
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.delegate = self;
    _cycleScrollView.titlesGroup = _titles;
//    _cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"doctor1.jpg"];
    [self.cycleView addSubview:_cycleScrollView];
    
    // --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _cycleScrollView.imageURLStringsGroup = _imgUrls;
    });

}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //传值并推出
    Diagnose_Info *info = [DiagnoseManager sharedDiagnoseManager].infoArr[index];
    DiagnoseInfoViewController *infoVC = [DiagnoseInfoViewController new];
    infoVC.info = info;
    
    [self.navigationController pushViewController:infoVC animated:YES];
}











//到‘病状信息页面’
- (IBAction)sicknessInfoAction:(UIButton *)sender {
    Diagnose_SicknessViewController *sicknessVC = [Diagnose_SicknessViewController new];
    [self.navigationController pushViewController:sicknessVC animated:YES];
}

//到‘检查项目’页面
- (IBAction)checkAction:(UIButton *)sender {
    Diagnose_CheckItemViewController *checkItemVC = [Diagnose_CheckItemViewController new];
    [self.navigationController pushViewController:checkItemVC animated:YES];
}

//到’手术项目‘页面
- (IBAction)operationAction:(UIButton *)sender {
    
    Diagnose_OperationViewController *operationVC = [Diagnose_OperationViewController new];
    
    [self.navigationController pushViewController:operationVC animated:YES];
}

//到健康食品页面
- (IBAction)healthAction:(UIButton *)sender {
    Diagnose_FoodViewController *foodVC = [Diagnose_FoodViewController new];
    [self.navigationController pushViewController:foodVC animated:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toSetTime:(UIBarButtonItem *)sender {
    
    SetAlertViewController *alertVC = [SetAlertViewController new];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:alertVC];
    [self presentViewController:n animated:YES completion:nil];
}
@end
