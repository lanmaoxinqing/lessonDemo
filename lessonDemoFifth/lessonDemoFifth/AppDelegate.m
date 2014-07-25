//
//  AppDelegate.m
//  lessonDemoFifth
//
//  Created by sky on 14-7-20.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "AppDelegate.h"
#import "ListTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    ListTableViewController *listTableVC=[[ListTableViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:listTableVC];
    self.window.rootViewController=nav;
    //注册消息推送
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    //应用未启动时接收到推送消息
    if(launchOptions){
        NSDictionary *userInfo=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self showNotification:userInfo];
        
    }
    
    return YES;
}

#pragma mark - 消息推送
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //保存deviceToken至服务器,作为消息推送时本机标识
    NSLog(@"%@",deviceToken);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //应用内接收到远程推送
//    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    NSLog(@"%@",userInfo);
    [self showNotification:userInfo];
}

-(void)showNotification:(NSDictionary *)userInfo{
    if (userInfo) {
        NSDictionary *dic = [userInfo objectForKey:@"aps"];
        if(dic){
            NSString *msg=[dic objectForKey:@"alert"];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息推送" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
