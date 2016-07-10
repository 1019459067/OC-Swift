//
//  WHTabBarViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/7.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHTabBarViewController.h"

@interface WHTabBarViewController ()
@property (strong, nonatomic) UIButton *btnPublish;
@end

@implementation WHTabBarViewController
- (UIButton *)btnPublish
{
    if (!_btnPublish) {
        _btnPublish = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPublish setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [_btnPublish setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        _btnPublish.frame = CGRectMake(0, 0, self.tabBar.frame.size.width / 5.0, self.tabBar.frame.size.height);
        [_btnPublish addTarget:self action:@selector(onActionPublish) forControlEvents:UIControlEventTouchUpInside];
        _btnPublish.center = CGPointMake(self.tabBar.frame.size.width * 0.5, self.tabBar.frame.size.height * 0.5);

    }
    return _btnPublish;
}
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

    [self setupChildOneVC:[[UIViewController alloc]init] title:nil image:@"" selectedImage:nil];

    [self setupChildOneVC:[[UIViewController alloc]init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];

    [self setupChildOneVC:[[UIViewController alloc]init] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /** add button **/
    [self.tabBar addSubview:self.btnPublish];

}
- (void)setupChildOneVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)strImg selectedImage:(NSString *)selectedImg
{
    vc.view.backgroundColor = WHRandomColor;
    vc.tabBarItem.title = title;
    if (strImg.length) {
        vc.tabBarItem.image = [UIImage imageNamed:strImg];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImg]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self addChildViewController:vc];
}
- (void)onActionPublish
{
    WHLogFunc;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
