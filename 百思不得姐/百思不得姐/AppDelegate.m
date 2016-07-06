//
//  AppDelegate.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/4.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor redColor];

    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    normalAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];

    UITabBarController *tabVC = [[UITabBarController alloc]init];
    
    UITabBarController *vc0 = [[UITabBarController alloc]init];
    vc0.view.backgroundColor = [UIColor redColor];
    vc0.tabBarItem.title = @"精华";
    vc0.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    vc0.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_essence_click_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc0.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [vc0.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    [tabVC addChildViewController:vc0];

    UIViewController *vc1 = [[UIViewController alloc]init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.tabBarItem.title = @"新帖";
    vc1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_new_click_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc1.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [vc1.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];

    [tabVC addChildViewController:vc1];

    UIViewController *vc2 = [[UIViewController alloc]init];
    vc2.view.backgroundColor = [UIColor redColor];
    vc2.tabBarItem.title = @"关注";
    vc2.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_friendTrends_click_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc2.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [vc2.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    [tabVC addChildViewController:vc2];

    UIViewController *vc3 = [[UIViewController alloc]init];
    vc3.view.backgroundColor = [UIColor redColor];
    vc3.tabBarItem.title = @"我";
    vc3.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    vc3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_me_click_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc3.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [vc3.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    [tabVC addChildViewController:vc3];

    
    self.window.rootViewController = tabVC;
    
    [self.window makeKeyAndVisible];
    return YES;
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
