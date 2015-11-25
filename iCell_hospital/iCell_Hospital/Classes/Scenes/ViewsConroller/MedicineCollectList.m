//
//  MedicineCollectList.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "MedicineCollectList.h"

@interface MedicineCollectList ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *array;
@end

@implementation MedicineCollectList

- (void)viewDidLoad {
    [[DBManager sharedManager] openDB];
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myMedicineCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

 
    _array = [[DBManager sharedManager]selectAllMedicine];
    return _array.count;
}

-(NSMutableArray *)array{
    
    if (!_array) {
        
        self.array = [NSMutableArray new];
        
    }
    
    return _array;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myMedicineCell" forIndexPath:indexPath];
    
    Medicine *medicine = _array[indexPath.row];
    
    cell.textLabel.text = medicine.name;
    
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        cell.contentView.nightBackgroundColor = UIColorFromRGB(0x343434);
        cell.contentView.normalBackgroundColor = [UIColor whiteColor];
        cell.textLabel.nightBackgroundColor = UIColorFromRGB(0x343434);
        cell.textLabel.normalBackgroundColor = [UIColor whiteColor];
        cell.textLabel.normalTextColor  = [UIColor blackColor];
        cell.textLabel.nightTextColor = [UIColor lightTextColor];
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    

    Medicine *medicine = _array[indexPath.row];
    

    
    MedicineDetailViewController *medicineDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"medicineDetailViewController"];
    
    medicineDetail.view.backgroundColor = [UIColor whiteColor];
    medicineDetail.medicine = medicine;
    
    //轻拍返回
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [medicineDetail.view addGestureRecognizer:tap];
    
    [self showViewController:medicineDetail sender:nil];

    
}
//轻拍返回
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      
        Medicine *medicine = _array[indexPath.row];
        [[DBManager sharedManager] deleteMedicineWithId:medicine];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [[DBManager sharedManager] closeDB];
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
