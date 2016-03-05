//
//  AppDelegate.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/2/28.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"TlUPVfv4VFf6O5sWppgvE1Koo80oqvhvBB0FePUC" clientKey:@"jObLwhnPEsWGRWkjAhwDVcPv1RUcznytT2X83iet"];
    //DBSession *dbSession = [[DBSession alloc]
                            //initWithAppKey:@"4szor352eu58atv"
                            //appSecret:@"irhmjazovmmq6ea"
                            //root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    //[DBSession setSharedSession:dbSession];
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |UIUserNotificationTypeBadge |UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
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
}

@end
