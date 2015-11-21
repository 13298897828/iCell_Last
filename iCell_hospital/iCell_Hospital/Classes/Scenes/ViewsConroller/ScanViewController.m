//
//  ScanViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/13.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "ScanViewController.h"
#import "ZBarSDK.h"
#import "nilViewController.h"
@interface ScanViewController ()<ZBarReaderViewDelegate>
@property (nonatomic,strong) ZBarReaderView* readerView;
@end


@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [button setTitle:@"返回" forState:(UIControlStateNormal)];
    button.frame = CGRectMake(self.view.frame.size.width / 2 - 30, self.view.frame.size.height / 4 * 3 - 30, 60, 30);
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initCamerma];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
//        [UIApplication sharedApplication].keyWindow.subviews[1].hidden = YES;
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [UIApplication sharedApplication].keyWindow.subviews[1].hidden = NO;
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_overLayView stopAnimation];
}

-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)initCamerma{
    
    {
        ZBarReaderView * reader = [ZBarReaderView new];
        ZBarImageScanner * scanner = [ZBarImageScanner new];
        [scanner setSymbology:ZBAR_PARTIAL config:0 to:0];
        [reader initWithImageScanner:scanner];
        reader.readerDelegate = self;
        
        const float h = self.mainView.bounds.size.height;
        const float w = self.mainView.bounds.size.width;
        //const float h_padding = w / 10.0;
        //const float v_padding = h / 10.0;
        CGRect reader_rect = CGRectMake(0, 0, w - 20, h);
        //    CGRect reader_rect = CGRectMake(h_padding, v_padding,
        //                                    w * 0.9, h * 0.9);//视图中的一小块,实际使用中最好传居中的区域
        CGRect reader_rect1 = CGRectMake(0, 0, w, h);//全屏模式
        reader.frame = reader_rect1;
        self.mainView.center = reader.center;
        reader.backgroundColor = [UIColor whiteColor];
        [reader start];
        self.mainView.backgroundColor = [UIColor blackColor];
        [self.mainView addSubview: reader];
        
        _overLayView = [[ZbarOverlayView alloc]initWithFrame:CGRectMake(reader.frame.origin.x, reader.frame.origin.y, reader.frame.size.width, reader.frame.size.height)];//添加覆盖视图
        //    [_overLayView startAnimation];
        _overLayView.transparentArea = reader_rect;//设置中间可选框大小
        [reader addSubview:_overLayView];
        reader.scanCrop = [self getScanCrop:reader_rect readerViewBounds:reader_rect1];;// CGRectMake(100 / h,0.5, 1/3.0,0.4);
    }

    
}

- (void) readerView:(ZBarReaderView *)readerView didReadSymbols: (ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    ZBarSymbol * s = nil;
    for (s in symbols)
    {
        NSString *data = s.data;
        
 
        if ([data hasPrefix:@"69"]) {
            
            NSString *urlString = [NSString stringWithFormat:@"code=%@",data];
            MedicineDetailViewController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"medicineDetailViewController"];
            
            [[MedicineHelper sharedManager] requestMedicineWithCode:kScan withHttpArg:urlString];
            [MedicineHelper sharedManager].result1 = ^(){
                
                if ([MedicineHelper sharedManager].medicine!= nil) {
                    //                detail.medicine = [Medicine new];
                    
                    detail.view.backgroundColor = [UIColor whiteColor];
                    
                    detail.medicine = [MedicineHelper sharedManager].medicine;
                    
                    [self showViewController:detail sender:nil];
                    
                }
                else{
                    
                    //                NSLog(@"%@",[[MedicineHelper sharedManager] requestMedicineWithCode:httpUrls withHttpArg:urlString].name);
                    NSLog(@"没有");
                    return ;
                    
                }
                
            };

            
        }else {
            
            
            nilViewController *nilVC = [nilViewController new];
            [self showViewController:nilVC sender:nil];
            
        }
        
        break;
        
    }
    
//    [[MedicineHelper sharedManager] requestMedicineWithCode:httpUrl withHttpArg:httpArg];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat fullWidth = readerViewBounds.size.width;
    CGFloat fullHeight = readerViewBounds.size.height;
    CGFloat x,y,width,height;
    x = rect.origin.x;
    y = rect.origin.y;
    width = rect.size.width;
    height = rect.size.height;
    if (x + width > fullWidth) {
        if (width > fullWidth) {
            width = fullWidth;
        }else{
            x = 0;
        }
    }
    if (y + height > fullHeight) {
        if (height > fullHeight) {
            height = fullHeight;
        }else{
            y = 0;
        }
    }
    CGFloat x1,y1,width1,height1;
    x1 = (fullWidth - width - x) / fullWidth;
    y1 = y / fullHeight;
    width1 = width / fullWidth;
    height1 = rect.size.height / readerViewBounds.size.height;
    return CGRectMake(y1, x1,height1, width1);
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
