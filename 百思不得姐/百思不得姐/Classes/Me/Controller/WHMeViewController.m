//
//  WHMeViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHMeViewController.h"
#import "WHSettingViewController.h"

@interface WHMeViewController ()

@end

@implementation WHMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHColorCommonBg;
    self.navigationItem.title = @"我的";
    WHLogFunc
    UIBarButtonItem *itemSetting = [UIBarButtonItem itemWithImage:@"mine-setting-icon" hightImag:@"mine-setting-icon-click" action:@selector(onActionSettingClick) addTarget:self];
    
    UIBarButtonItem *itemMoon = [UIBarButtonItem itemWithImage:@"mine-moon-icon" hightImag:@"mine-moon-icon-click" action:@selector(onActionMoonClick) addTarget:self];
    
    self.navigationItem.rightBarButtonItems = @[itemSetting,itemMoon];
}
 
- (void)onActionSettingClick
{
    WHSettingViewController *vc = [[WHSettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onActionMoonClick
{
    WHLogFunc
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
