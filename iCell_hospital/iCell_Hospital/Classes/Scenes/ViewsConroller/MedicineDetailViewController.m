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

    // Do any additional setup after loading the view.
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
        
    }
 
    
    
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
