//
//  HospitalCollectList.m
//  iCell_Hospital
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "HospitalCollectList.h"

@interface HospitalCollectList ()

@end

@implementation HospitalCollectList

static NSString *const cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
  [[DBManager sharedManager] findAllHospitalInDataBase];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
//    [[DBManager sharedManager] findAllHospitalInDataBase];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [DBManager sharedManager].allHospitalArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Hospital *hospital=[DBManager sharedManager].allHospitalArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = hospital.name;
    
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



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Hospital *hospital = [DBManager sharedManager].allHospitalArray[indexPath.row];
        
        [[DBManager sharedManager] insertHospital:hospital];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [HospitalDetailViewController sharedHospitalDetalVC].hospital = [DBManager sharedManager].allHospitalArray[indexPath.row];

    //轻拍返回
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [[HospitalDetailViewController sharedHospitalDetalVC].view addGestureRecognizer:tap];
    
    [self presentViewController:[HospitalDetailViewController sharedHospitalDetalVC] animated:YES completion:^{
        
    }];
}

//轻拍返回
- (void)back{
    [[HospitalDetailViewController sharedHospitalDetalVC] dismissViewControllerAnimated:YES completion:nil];
}


@end
