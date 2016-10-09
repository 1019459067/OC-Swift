//
//  AppDelegate.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/4.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "AppDelegate.h"
#import "WHTabBarViewController.h"

@interface AppDelegate ()

@end

UIWindow *window_;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[WHTabBarViewController alloc]init];;
    
    [self.window makeKeyAndVisible];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        window_ = [[UIWindow alloc]init];
        window_.frame = [UIApplication sharedApplication].statusBarFrame;
        window_.windowLevel = UIWindowLevelAlert;
        window_.backgroundColor = [UIColor clearColor];
        window_.hidden = NO;
        
        [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapWindowTop)]];
    });
    return YES;
}
- (void)onTapWindowTop
{
    [self findScrollViewInView:[UIApplication sharedApplication].keyWindow];
}
- (void)findScrollViewInView:(UIView *)view
{
    for (UIView *subView in view.subviews)
    {
        [self findScrollViewInView:subView];
    }
    
    if (![view isKindOfClass:[UIScrollView class]]) return;

    //判断view是否和window有重叠
    if (![view intersectsRectWithView:[UIApplication sharedApplication].keyWindow]) return;
    
    UIScrollView *scrollView = (UIScrollView *)view;
    CGPoint offset = scrollView.contentOffset;
    offset.y = -scrollView.contentInset.top;
    [scrollView setContentOffset:offset animated:YES];
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
