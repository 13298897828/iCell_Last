//
//  AppDelegate.m
//  iCell_Hospital
//
//  Created by 张天琦 on 15/11/9.
//  Copyright © 2015年 张天琦. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewControllerForFirstStart.h"
#import "sys/utsname.h"
#import "TabViewController.h"
#import "AFNetworkingManager.h"

@interface AppDelegate ()

@property (nonatomic,strong)NSString *token;

@property(nonatomic,strong)AVPlayer *player;
@end

@implementation AppDelegate

#define RONGCLOUD_IM_USER_TOKEN @"x18ywvqf800pc"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //userDefault
    appDelegate.appDefault = [NSUserDefaults standardUserDefaults];
    [appDelegate.appDefault setObject:NULL forKey:@"one"];
    
//    //注册推送
//    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    
    //初始化融云SDK。
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_USER_TOKEN];
    
//    if ([application
//         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings
//                                                settingsForTypes:(UIUserNotificationTypeBadge |
//                                                                  UIUserNotificationTypeSound |
//                                                                  UIUserNotificationTypeAlert)
//                                                categories:nil];
//        [application registerUserNotificationSettings:settings];
//    } else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeAlert |
//        UIRemoteNotificationTypeSound;
//        [application registerForRemoteNotificationTypes:myTypes];
//    }
//    
 
    
    NSUUID *str = [UIDevice currentDevice].identifierForVendor;
    NSString *str1 = str.UUIDString;
    NSString *string = [NSString stringWithFormat:kChat,str1];
//        NSLog(@"%@",string);
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
          {
              if (!data) {
                  NSLog(@"错误");
                  return ;
              }
              //          NSString *da = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
              _token = dict[@"token"];
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  [[RCIM sharedRCIM] connectWithToken:_token success:^(NSString *userId) {
                      // Connect 成功
                      NSLog(@"链接成功");
                  }
                                                error:^(RCConnectErrorCode status) {
                                                    // Connect 失败
                                                    NSLog(@"链接失败");
                                                }
                                       tokenIncorrect:^() {
                                           // Token 失效的状态处理
                                       }];
              });
              
          }];
    [task resume];
    
    
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"1"];
    UIMutableApplicationShortcutItem *item = [[UIMutableApplicationShortcutItem alloc] initWithType:@"yiyuan" localizedTitle:@"搜索医院" localizedSubtitle:@"" icon:icon userInfo:@{@"key": @"value"}];
    
    
    
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"22"];
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"yaopin" localizedTitle:@"搜索药品" localizedSubtitle:@"" icon:icon1 userInfo:@{@"key": @"value"}];
    
    
    
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ling1"];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"tixing" localizedTitle:@"添加提醒" localizedSubtitle:@"" icon:icon2 userInfo:@{@"key": @"value"}];
    
    
    [UIApplication sharedApplication].shortcutItems = @[item,item1,item2];
    
    
    return YES;
}


//func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
//}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    
    if ([shortcutItem.type isEqualToString:@"yiyuan"]) {
        
        HosipitalViewController *hospitalVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HosipitalViewController"];
        
        TabViewController *tabViewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabViewController"];
        self.window.rootViewController = tabViewController;
        tabViewController.selectedIndex = 0;
        
    }
    
    if ([shortcutItem.type isEqualToString:@"yaopin"]) {
        
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"na"];
 
        TabViewController *tabViewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabViewController"];
        self.window.rootViewController = tabViewController;
        tabViewController.selectedIndex = 3;

    }
    if ([shortcutItem.type isEqualToString:@"tixing"]) {
        
        SetAlertViewController *setAlertVC = [SetAlertViewController new];
        setAlertVC.flag = YES;
        
        [self.window setRootViewController:setAlertVC];
    }
    
    

  
}



-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    //声音集成器
    AVSpeechSynthesizer *speechSy = [[AVSpeechSynthesizer alloc] init];
    //发声器
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"it is time to have medicine"];
    
    [speechSy speakUtterance:utterance];
    
    //哪国语言
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    //语速
    utterance.rate = 0.5;
    //音高
    utterance.pitchMultiplier = 1.0;
    
    
    
    //提示音乐
    self.player = [AVPlayer new];
    //创建item对象
    NSURL *url = [NSURL URLWithString:urlStr_mp3];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    //切换到当前的音乐即可
    [_player replaceCurrentItemWithPlayerItem:item];
    
    [_player play];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(pauseAction) userInfo:nil repeats:NO];
    
}

- (void)pauseAction{
    [_player pause];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Tiqnqi-Zhang.iCell_Hospital" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iCell_Hospital" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iCell_Hospital.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
