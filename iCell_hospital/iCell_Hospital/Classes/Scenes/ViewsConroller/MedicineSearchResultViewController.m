//
//  MedicineSearchResultViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/11.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "MedicineSearchResultViewController.h"
#import "MedicineCollectionViewCell.h"
@interface MedicineSearchResultViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *searchMedicineCollectionView;
@property (nonatomic,strong)NSMutableArray *daArray;
@end
static  NSString  * const headerReuseId = @"aaa";
@implementation MedicineSearchResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    [_searchMedicineCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseId];
    [_daArray addObjectsFromArray:[MedicineHelper sharedManager].MedicineArray];
    [MedicineHelper sharedManager].result = ^{
        
        [self.searchMedicineCollectionView reloadData];
        
    };
    
     [self.searchMedicineCollectionView registerNib:[UINib nibWithNibName:@"MedicineCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MedicineSearchCollectionCell"];
    
    _searchMedicineCollectionView.delegate = self;
    _searchMedicineCollectionView.dataSource = self;
    
       _searchMedicineCollectionView.backgroundColor = [UIColor colorWithRed:110 / 255.0 green:221 / 255.0 blue:247 / 255.0  alpha:.3];


    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController  setNavigationBarHidden:NO animated:YES];
 
    
}

#pragma mark - 区头，区尾（每个组的）
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //区头
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseId forIndexPath:indexPath];
     header.backgroundColor = [UIColor cyanColor];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tishi"]];
    
//    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = CGRectMake(0, 0, header.frame.size.width, header.frame.size.height);
    
    
    
//    [self.view addSubview:imgView];
//    imgView.backgroundColor = [UIColor blackColor];
    [header addSubview:imgView];
//    imgView.backgroundColor = [UIColor redColor];
    return header;
    
 
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(CGRectGetWidth(self.view.frame), 190);

}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
     return [MedicineHelper sharedManager].MedicineInfoArray.count;
    
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    MedicineCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"MedicineSearchCollectionCell" forIndexPath:indexPath];
    for(UIView * view in cell.subviews){
        
        if([view isKindOfClass:[UIImageView class]])
            
        {
            
            [view removeFromSuperview];
            
        }
        
    }
    Medicine *medicine = [MedicineHelper sharedManager].MedicineInfoArray[indexPath.row];
    //        UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
    
  
    
        [cell.medicineImg sd_setImageWithURL:[NSURL URLWithString:medicine.img]];
        cell.medicineName.text = medicine.name;
        cell.medicineName.textColor = [UIColor whiteColor];
        cell.medicineName.font = [UIFont systemFontOfSize:14];
    
        [cell.medicineImg sd_setImageWithURL:[NSURL URLWithString:medicine.img]];
    cell.medicineName.textColor = [UIColor colorWithWhite:0.498 alpha:1.000];
        cell.medicineName.text = medicine.name;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Medicine *medicine = [MedicineHelper sharedManager].MedicineInfoArray[indexPath.row];
    
    MedicineDetailViewController *medicineDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"medicineDetailViewController"];
    
    medicineDetail.view.backgroundColor = [UIColor whiteColor];
    medicineDetail.medicine = medicine;
    medicineDetail.flag = YES;

    [self showViewController:medicineDetail sender:nil];
    
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    

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
