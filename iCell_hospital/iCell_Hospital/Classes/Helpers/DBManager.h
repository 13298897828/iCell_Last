//
//  DBManager.h
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/18.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <FMDatabase.h>
@class Medicine;
@class Hospital;
@interface DBManager : NSObject
//疾病
@property (nonatomic,strong)NSMutableArray *sicknessArr;
//药品
@property (nonatomic,strong)NSMutableArray *collectionMedicineArray;

+(instancetype)sharedManager;
//打开数据库
-(void)openDB;
//关闭数据库
-(void)closeDB;

-(void)deleteMedicineWithId:(Medicine *)medicine;
-(NSMutableArray *)selectAllMedicine;
-(void)insertMedicine:(Medicine *)medicine;

-(void)createMedicineTable;
-(BOOL )selectMedicineFormTable:(Medicine *)medicine;

//医院数据库
- (void)insertHospital:(Hospital *)hospital;
- (BOOL)findHospitalInDataBase:(Hospital *)hospital;



#pragma mark - 诊断
- (void)insertSickness:(Diagnose_Sickness *)sickness;
- (BOOL)selectSickness:(Diagnose_Sickness *)sickness;
- (NSArray *)selectAllSickness;
- (void)deleteSickness:(Diagnose_Sickness *)sickness;

@end
