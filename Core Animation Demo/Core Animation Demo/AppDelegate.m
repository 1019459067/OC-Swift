//
//  AppDelegate.m
//  Core Animation Demo
//
//  Created by 肖伟华 on 2016/11/5.
//  Copyright © 2016年 XWH. All rights reserved.
//
/*
 学习链接：
 http://www.cnblogs.com/kenshincui/p/3972100.html
 */

#import "AppDelegate.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "Test3ViewController.h"
#import "Test4ViewController.h"
#import "Test5ViewController.h"
#import "Test6ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    int tag = 6;
    if (tag == 1)
    {
        Test1ViewController *vc = [[Test1ViewController alloc]init];
        self.window.rootViewController = vc;
    }
    if (tag == 2)
    {
        Test2ViewController *vc = [[Test2ViewController alloc]init];
        self.window.rootViewController = vc;
    }
    if (tag == 3)
    {
        Test3ViewController *vc = [[Test3ViewController alloc]init];
        self.window.rootViewController = vc;
    }
    if (tag == 4)
    {
        Test4ViewController *vc = [[Test4ViewController alloc]init];
        self.window.rootViewController = vc;
    }
    if (tag == 5)
    {
        Test5ViewController *vc = [[Test5ViewController alloc]init];
        self.window.rootViewController = vc;
    }
    if (tag == 6)
    {
        Test6ViewController *vc = [[Test6ViewController alloc]init];
        self.window.rootViewController = vc;
    }
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
