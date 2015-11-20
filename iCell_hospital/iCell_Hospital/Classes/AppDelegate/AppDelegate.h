//
//  AppDelegate.h
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <EAIntroView/EAIntroView.h>
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface AppDelegate : UIResponder <UIApplicationDelegate,EAIntroDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//userDefault
@property (retain, nonatomic)NSUserDefaults *appDefault;
@end

