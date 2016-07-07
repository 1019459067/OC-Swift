//
//  WHTabBarViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/7.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHTabBarViewController.h"

@interface WHTabBarViewController ()

@end

@implementation WHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITabBarItem *item = [UITabBarItem appearance];
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    normalAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [item setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    
    [self setupChildOneVC:[[UITableViewController alloc]init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];

    [self setupChildOneVC:[[UIViewController alloc]init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];

    [self setupChildOneVC:[[UIViewController alloc]init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];

    [self setupChildOneVC:[[UIViewController alloc]init] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];

}
- (void)setupChildOneVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)strImg selectedImage:(NSString *)selectedImg
{
    vc.view.backgroundColor = [self arc4randomColor];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:strImg];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImg]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:vc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIColor *)arc4randomColor
{
    return [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
}
@end
