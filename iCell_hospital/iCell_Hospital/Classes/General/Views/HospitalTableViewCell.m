//
//  HospitalTableViewCell.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalTableViewCell.h"

@interface HospitalTableViewCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _count;
    NSInteger _count2;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray  *hosArray;

@property(nonatomic,strong)NSMutableArray *hotArray;




@end

@implementation HospitalTableViewCell

static NSString *const cellID = @"cellID";
static NSString *const kheaderIdentifier = @"kheaderIdentifierID";

- (void)awakeFromNib {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) collectionViewLayout:flowLayout];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HospitalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    //注册headerView Nib的view需要继承UICollectionReusableView
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    
    [self.contentView addSubview:self.collectionView];
    
    self.collectionView.scrollEnabled = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
//    夜间模式
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        
        self.collectionView.normalBackgroundColor = [UIColor whiteColor];
        self.collectionView.nightBackgroundColor = UIColorFromRGB(0x343434);
    }];
    
}

#pragma mark collectionView协议方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hosArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(([UIScreen mainScreen].bounds.size.width-20) * 0.5, 120);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    reuseIdentifier = kheaderIdentifier;
    
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    if (view.subviews.count) {
//        NSLog(@"%ld",view.subviews.count);
        [view.subviews[0] removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, view.frame.size.width, 30)];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        label.text = @"热门医院";
        @weakify(self);
        [self addColorChangedBlock:^{
            @strongify(self);
            
            label.normalTextColor = [UIColor blackColor];
            label.nightTextColor = [UIColor lightTextColor];
        }];

        [view addSubview:label];
    }
    return view;
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={320,40};
    return size;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    HospitalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    Hospital *hospital = nil;
        for (int i=0; i<self.hosArray.count; i++) {
        
            if (_count<self.hosArray.count) {
                hospital = self.hosArray[_count++];
            if ([hospital.level  rangeOfString:@"三级甲等"].location !=NSNotFound) {
                cell.hospital = hospital;
                [self.hotArray addObject:hospital];
                return cell;
            }
        }
            
}
    for (int i=0; i<self.hosArray.count; i++) {

        if(_count2<self.hosArray.count){
              hospital   = self.hosArray[_count2++];
            if ([hospital.level  rangeOfString:@"二级甲等"].location !=NSNotFound) {
            cell.hospital = hospital;
            [self.hotArray addObject:hospital];
            return cell;
        }
    }
}
    NSInteger tempCount = indexPath.row;
    hospital = self.hosArray[tempCount];
    cell.hospital = hospital;
    [self.hotArray addObject:hospital];
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",self.nextResponder.nextResponder);
    [HospitalDetailViewController sharedHospitalDetalVC].hospital = self.hotArray[indexPath.row];
    [self.fatherViewController.navigationController pushViewController:[HospitalDetailViewController sharedHospitalDetalVC] animated:YES];
}

- (void)setDataArray:(NSArray *)dataArray{
    self.hosArray = [dataArray copy];
    _count = 0;
    _count2 = 0;
    
    [self.hotArray removeAllObjects];
//    选择了新的地区 刷新collectionView
    [self.collectionView reloadData];
    
}

- (NSMutableArray *)hotArray{
    if (_hotArray == nil) {
        _hotArray = [NSMutableArray arrayWithCapacity:6];
    }
    return _hotArray;
}

- (NSMutableArray *)hosArray{
    if (_hosArray == nil) {
        _hosArray = [NSMutableArray arrayWithCapacity:4];
    }
    return _hosArray;
}

@end
