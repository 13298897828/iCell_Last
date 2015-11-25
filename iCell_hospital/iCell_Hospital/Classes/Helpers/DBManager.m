//
//  DBManager.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/18.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "DBManager.h"


@interface DBManager ()

@property(nonatomic,strong)NSMutableArray *hospitalArray;

@end

@implementation DBManager


+(instancetype)sharedManager{
 
    static DBManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [DBManager new];

        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentDirectory = [paths objectAtIndex:0];
        
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
        
        db = [FMDatabase databaseWithPath:dbPath] ;
        
        if (![db open]) {
            
            NSLog(@"Could not open db.");

        }
        //        医院表
           [db executeUpdate:@"CREATE TABLE  if not exists hospitalTable('address' TEXT, 'area' TEXT, 'count' TEXT, 'fax' TEXT, 'fcount' TEXT, 'gobus' TEXT, '_id' TEXT, 'img' TEXT, 'level' TEXT, 'mail' TEXT, 'mtype' TEXT, 'name' TEXT, 'nature' TEXT, 'rcount' TEXT, 'tel' TEXT, 'url' TEXT, 'x' TEXT, 'y' TEXT, 'zipcode' TEXT, 'message' TEXT,'isFavourit' BOOLEAN);"];
//          天气表
            [db executeUpdate:@"CREATE TABLE if not exists 'forcastWeatherTable' ('date' TEXT, 'dayTemp' TEXT, 'nightTemp' TEXT,'cityName'TEXT,'week' TEXT);"];
        [db executeUpdate:@"CREATE TABLE if not exists 'liveWeatherTable' ('weather' TEXT,'temperature' TEXT,'windDirection' TEXT,'windPower' TEXT,'humidity' TEXT,'cityName' TEXT);"];
//        诊断表
             [db executeUpdate:@"CREATE TABLE if not exists 'sicknessTable' ('desc' TEXT, 'causetext' TEXT, 'detailtext' TEXT, 'drug' TEXT, 'img' TEXT, 'name' TEXT);"];
        
        
        if (db) {
            return ;
        }
    

    });
    return manager;
}


static  FMDatabase *db = nil;


//打开数据库
-(void)openDB{
    if ([db open]) {
        NSLog(@"数据库打开成功");
    }
    else{
        NSLog(@"打开失败");
    }
}

//关闭数据库
-(void)closeDB{
    
    if ([db close]) {
        NSLog(@"数据库关闭成功");
    }else{
        NSLog(@"数据库关闭失败");
    }
    
    
}
-(void)createMedicineTable{
    
    if ([db executeUpdate:@"CREATE TABLE if not exists 'medicineList' ('ID' TEXT, 'img' TEXT, 'keywords' TEXT, 'name' TEXT, 'descript' TEXT, 'message' TEXT, 'tap' TEXT, 'messageArray' BLOB, 'price' INTEGER, 'code' TEXT);"]) {
        
        NSLog(@"表创建成功");
    }
    
}



-(void)insertMedicine:(Medicine *)medicine{

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:medicine.messageArray];

//    NSArray *arr2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
//    @"CREATE TABLE if not exists 'medicineList' ('ID' TEXT, 'img' TEXT, 'keywords' TEXT, 'name' TEXT, 'descript' TEXT, 'message' TEXT, 'tap' TEXT, 'messageArray' BLOB, 'price' INTEGER, 'code' TEXT);"]
    
    
    if ([db executeUpdate:@"INSERT INTO 'medicineList' VALUES (?,?,?,?,?,?,?,?,?,?)",medicine.ID,medicine.img,medicine.keywords,medicine.name,medicine.descript,medicine.message,medicine.tap,data,[NSNumber numberWithInt:medicine.price],medicine.code]) {
        
//        [_collectionMedicineArray addObject:medicine];
        NSLog(@"药品收藏成功");
    }else{
        
        NSLog(@"药品删除失败");
    }
    
}

-(NSMutableArray *)selectAllMedicine{
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM medicineList"];
 
    [_collectionMedicineArray removeAllObjects];
    
    while ([rs next]) {

        NSString *ID = [rs stringForColumn:@"ID"];
//        int age = [rs intForColumn:@"Age"];
        NSString *img = [rs stringForColumn:@"img"];
        NSString *keywords = [rs stringForColumn:@"keywords"];
        NSString *name = [rs stringForColumn:@"name"];
        NSString *descript = [rs stringForColumn:@"descript"];
        NSString *message = [rs stringForColumn:@"message"];
        NSString *tap = [rs stringForColumn:@"tap"];
        int price = [rs intForColumn:@"price"];
        NSString *code = [rs stringForColumn:@"code"];
        NSData *messageArrayData = [rs dataForColumn:@"messageArray"];
        NSArray *messageArray = [NSKeyedUnarchiver unarchiveObjectWithData:messageArrayData];

        
        Medicine *collectMedicine = [Medicine new];
        collectMedicine.ID = ID;
        collectMedicine.img = img;
        collectMedicine.keywords = keywords;
        collectMedicine.name = name;
        collectMedicine.descript = descript;
        collectMedicine.message = message;
        collectMedicine.tap = tap;
        collectMedicine.price = price;
        collectMedicine.code = code;
        [collectMedicine.messageArray addObjectsFromArray:messageArray];
        [self.collectionMedicineArray addObject:collectMedicine];
//        NSLog(@"%@",collectMedicine.messageArray);
    }
    [rs close];
    return _collectionMedicineArray;
    
}


-(BOOL )selectMedicineFormTable:(Medicine *)medicine{
    
    FMResultSet *rs = [db executeQuery:@"SELECT name FROM medicineList"];
    
    
    
    while ([rs next]) {
        
        //        executeUpdate:@"CREATE TABLE 'medicineList' if not exist('ID' TEXT, 'img' TEXT, 'keywords' TEXT, 'name' TEXT, 'descript' TEXT, 'message' TEXT, 'tap' TEXT, 'messageArray' BLOB, 'price' INTEGER, 'code' TEXT);"];
        
 
        NSString *name = [rs stringForColumn:@"name"];
      
        if ([medicine.name isEqualToString:name]) {
            
            [rs close];
            return YES;
            
        }
        
    }
    [rs close];
    return NO;
    
}




-(void)deleteMedicineWithId:(Medicine *)medicine{
    
    if ([db executeUpdate:@"delete from medicineList where ID = ?",medicine.ID]) {
        NSLog(@"删除数据成功");
        [_collectionMedicineArray removeObject:medicine];
    }else{
        NSLog(@"删除数据失败");
        
    }
}


#pragma mark -懒加载
-(NSMutableArray *)collectionMedicineArray{
    
    if (!_collectionMedicineArray) {
        
        self.collectionMedicineArray = [NSMutableArray new];
        
    }
    
    return _collectionMedicineArray;
    
}

- (NSMutableArray *)sicknessArr{
    if (!_sicknessArr) {
        
        self.sicknessArr = [NSMutableArray new];
    }
    
    return _sicknessArr;
}


//医院

- (BOOL)findHospitalInDataBase:(Hospital *)hospital{
    FMResultSet *rs = [db executeQuery:@"SELECT name FROM hospitalTable"];
    
    while ([rs next]) {
        
        NSString *name = [rs stringForColumn:@"name"];
        
        if ([hospital.name isEqualToString:name]) {
    
            return YES;
        }
    }

    return NO;
    
}

- (void)insertHospital:(Hospital *)hospital{
    
    [self openDB];
    if ([self findHospitalInDataBase:hospital]) {
        [db executeUpdate:@"DELETE FROM hospitalTable WHERE name = ?",hospital.name];
        [self.hospitalArray removeObject:hospital];
          [self closeDB];
        return;
    }
    
    [db executeUpdate:@"INSERT INTO hospitalTable(address,area,count,fax,fcount,gobus,_id,img,level,mail,mtype,name,nature,rcount,tel,url,x,y,zipcode,message,isFavourit)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",hospital.address,hospital.area,hospital.count,hospital.fax,hospital.fcount,hospital.gobus,hospital._id,hospital.img,hospital.level,hospital.mail,hospital.mtype,hospital.name,hospital.nature,hospital.rcount,hospital.tel,hospital.url,hospital.x,hospital.y,hospital.zipcode,hospital.message,[NSNumber numberWithBool:hospital.isFavourit]];
    
    [self closeDB];
}

- (void)findAllHospitalInDataBase{
    
    
    [self openDB];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM hospitalTable"];
    [self.hospitalArray removeAllObjects];
    while ([rs next]) {
        Hospital *hospital =[Hospital new];
        hospital.name =[rs stringForColumn:@"name"];
        hospital._id = [rs stringForColumn:@"_id"];
        hospital.mtype = [rs stringForColumn:@"mtype"];
        hospital.level = [rs stringForColumn:@"level"];
        hospital.img = [rs stringForColumn:@"img"];
        hospital.address =[rs stringForColumn:@"address"];
        hospital.x = [rs stringForColumn:@"x"];
        hospital.y = [rs stringForColumn:@"y"];
        hospital.isFavourit = [rs stringForColumn:@"isFavourit"];
        hospital.gobus = [rs stringForColumn:@"gobus"];
        [self.hospitalArray addObject:hospital];
    }

    [self closeDB];
    
}


- (NSArray *)allHospitalArray{
    return [self.hospitalArray copy];
}

#pragma mark 天气

- (void)insertForcastWeather:(AMapLocalWeatherForecast *)forecast{
    [self openDB];
    
    FMResultSet *rs = [db executeQuery:@"SELECT cityName FROM forcastWeatherTable"];
    
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"cityName"];
        if ([name isEqualToString:forecast.city]) {
            for (AMapLocalDayWeatherForecast *weatherForcast in forecast.casts) {
                  [db executeUpdate:@"UPDATE forcastWeatherTable SET dayTemp = ? ,nightTemp = ? ,week = ? WHERE date = ?",weatherForcast.dayTemp,weatherForcast.nightTemp,weatherForcast.week,weatherForcast.date];
            }
            [self closeDB];
           return;
        }
    }
    
    for (AMapLocalDayWeatherForecast *weatherForcast in forecast.casts) {
              [db executeUpdate:@"INSERT INTO forcastWeatherTable(date,dayTemp,nightTemp,week,cityName)VALUES(?,?,?,?,?)",weatherForcast.date,weatherForcast.dayTemp,weatherForcast.nightTemp,weatherForcast.week,forecast.city] ;
    }

    [self closeDB];
}

- (NSMutableArray *)findForcastWeatherInDatabase{
    [self openDB];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM forcastWeatherTable"];
    while ([rs next]) {
    NSString *name = [rs stringForColumn:@"cityName"];
        
        if (![HospitalHelper sharedHospitalHelper].currentCityName) {
            [HospitalHelper sharedHospitalHelper].currentCityName = @"北京市";
        }
#warning 以定位的城市为基准
        if ([name isEqualToString:[HospitalHelper sharedHospitalHelper].currentCityName]) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[rs stringForColumn:@"date"],@"date",[rs stringForColumn:@"nightTemp"],@"nightTemp",[rs stringForColumn:@"week"],@"week",[rs stringForColumn:@"dayTemp"],@"dayTemp",nil];
            [array addObject:dict];
        }
    }
    
    
    
    [self closeDB];
    
    return array;
}

- (void)insertLiveWeather:(AMapLocalWeatherLive *)liveInfo{
    [self openDB];
    
    FMResultSet *rs = [db executeQuery:@"SELECT cityName FROM liveWeatherTable"];
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"cityName"];
        if ([name isEqualToString: liveInfo.city]) {
            [db executeUpdate:@"UPDATE liveWeatherTable SET weather = ?,temperature = ?,windDirection = ?,windPower = ?,humidity = ? WHERE cityName = ?",liveInfo.weather,liveInfo.temperature,liveInfo.windDirection,liveInfo.windPower,liveInfo.humidity,liveInfo.city];
            [self closeDB];
            return;
        }
    }
    
    [db executeUpdate:@"INSERT INTO liveWeatherTable(weather,temperature,windDirection,windPower,humidity,cityName)VALUES(?,?,?,?,?,?)",liveInfo.weather,liveInfo.temperature,liveInfo.windDirection,liveInfo.windPower,liveInfo.humidity,liveInfo.city] ;
    
    [self closeDB];
}

- (NSDictionary *)findLiveWeatherInformationInDatabase{
    [self openDB];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM liveWeatherTable"];
    NSDictionary *dict =  [NSDictionary dictionary];
    while ([rs next]){
        NSString *name = [rs stringForColumn:@"cityName"];
        
#warning 以定位的城市为基准
        if (![HospitalHelper sharedHospitalHelper].currentCityName) {
            [HospitalHelper sharedHospitalHelper].currentCityName = @"北京市";
        }
        if ([name isEqualToString:[HospitalHelper sharedHospitalHelper].currentCityName]) {
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[rs stringForColumn:@"weather"],@"weather",[rs stringForColumn:@"temperature"],@"temperature",[rs stringForColumn:@"windDirection"],@"windDirection",[rs stringForColumn:@"windPower"],@"windPower",[rs stringForColumn:@"humidity"],@"humidity",[rs stringForColumn:@"cityName"],@"cityName", nil];
        }
         
    }
    
    
    [self closeDB];
    
    return dict;
}


#pragma mark - 诊断
//插入病状
- (void)insertSickness:(Diagnose_Sickness *)sickness{
    
    if (!sickness.name) {
        return;
    }
    
    [self openDB];
    
    if ([self selectSickness:sickness]) {
        [db executeUpdate:@"DELETE FROM sicknessTable WHERE name = ?",sickness.name];
    }
    int res = [db executeUpdate:@"INSERT INTO sicknessTable(desc,causetext,detailtext,drug,img,name)VALUES(?,?,?,?,?,?)",sickness.desc,sickness.causetext,sickness.detailtext,sickness.drug,sickness.img,sickness.name];
    NSLog(@"%@",sickness.name);
    if (res) {
        
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
    
    [self closeDB];
}

//是否已经存在
- (BOOL)selectSickness:(Diagnose_Sickness *)sickness{
    
    FMResultSet *rs = [db executeQuery:@"SELECT name FROM sicknessTable"];
    
    while ([rs next]) {
        
        NSString *name = [rs stringForColumn:@"name"];
        
        if ([sickness.name isEqualToString:name]) {
            return YES;
        }
    }
    [rs close];
    
    return NO;
}

//查找所有存储的病状
- (NSArray *)selectAllSickness{
    
    [self openDB];
    [_sicknessArr removeAllObjects];
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM sicknessTable"];
    
    while ([rs next]) {
        
        NSString *name = [rs stringForColumn:@"name"];
        NSString *img = [rs stringForColumn:@"img"];
        NSString *desc = [rs stringForColumn:@"desc"];
        NSString *causetext = [rs stringForColumn:@"causetext"];
        NSString *detailtext = [rs stringForColumn:@"detailtext"];
        NSString *drug = [rs stringForColumn:@"drug"];
        
        Diagnose_Sickness *sickness = [Diagnose_Sickness new];
        
        sickness.name = name;
        sickness.img = img;
        sickness.desc = desc;
        sickness.detailtext = detailtext;
        sickness.causetext = causetext;
        sickness.drug = drug;
        
        [self.sicknessArr addObject:sickness];
    }
    [rs close];
    [self closeDB];
    
    return _sicknessArr;
}

//删除存储的病状信息
- (void)deleteSickness:(Diagnose_Sickness *)sickness{
    
    [self openDB];
    if ([db executeUpdate:@"delete from sicknessTable where name = ?",sickness.name]) {
        NSLog(@"删除数据成功");
        [_sicknessArr removeObject:sickness];
    }else{
        NSLog(@"删除数据失败");
        
    }
    [self closeDB];
}


- (NSMutableArray *)hospitalArray{
    if (_hospitalArray == nil) {
        _hospitalArray = [NSMutableArray arrayWithCapacity:6];
        
    }
    return _hospitalArray;
}


@end
