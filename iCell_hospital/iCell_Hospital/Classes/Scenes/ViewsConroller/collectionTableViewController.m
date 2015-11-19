//
//  collectionTableViewController.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/18.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "collectionTableViewController.h"

@interface collectionTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableDictionary *dataDictionary;
@end

@implementation collectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"collectionCell"];
    [[DBManager sharedManager] openDB];
    [[DBManager sharedManager] selectAllMedicine];
    [[DBManager sharedManager] selectAllSickness];
    
    [_dataDictionary setObject:[DBManager sharedManager].collectionMedicineArray forKey:@"M"];
    [_dataDictionary setObject:[DBManager sharedManager].sicknessArr forKey:@"S"];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [[DBManager sharedManager] closeDB];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return @"收藏的医院";
        
    }if (section == 1) {
        
        return @"收藏的诊断";
    }
    
    return @"收藏的药品";
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell" forIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        
//        cell.imageView.image = [UIImage imageNamed:@"hospital"];
//        cell.textLabel.text = @"收藏的医院";
//    }
//        
//        
//    if (indexPath.row == 1) {
//        
//        cell.imageView.image = [UIImage imageNamed:@"zhenduan"];
//        cell.textLabel.text = @"收藏的诊断";
//    }
//    
//    if (indexPath.row == 2) {
//        
//        cell.imageView.image = [UIImage imageNamed:@"tongrentang"];
//        cell.textLabel.text = @"收藏的药品";
//    }
    
    NSString *key = self.dataDictionary.allKeys[indexPath.section];
    NSArray *array = _dataDictionary[key];
    
    if (indexPath.section == 0) {
        
        Hospital *hospital = [Hospital new];
        hospital = array[indexPath.row];
        cell.textLabel.text = hospital.name;
    }
    if (indexPath.section == 1) {
        
        Diagnose_Sickness *diagnose = [Diagnose_Sickness new];
        diagnose = array[indexPath.row];
        cell.textLabel.text =diagnose.name;
        
    }
    
    if (indexPath.section == 2) {
        
        Medicine *medicine = [Medicine new];
        medicine = array[indexPath.row];
        cell.textLabel.text = medicine.name;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

-(NSMutableDictionary *)dataDictionary{
    
    if (!_dataDictionary) {
        
        self.dataDictionary = [NSMutableDictionary new];
        
    }
    
    return _dataDictionary;
    
}

@end
