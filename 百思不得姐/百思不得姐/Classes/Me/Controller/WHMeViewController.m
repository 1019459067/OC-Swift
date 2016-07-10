//
//  WHMeViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHMeViewController.h"

@interface WHMeViewController ()

@end

@implementation WHMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHColorCommonBg;
    WHLogFunc
    self.navigationItem.title = @"我的";
    WHLogFunc
    UIButton *buttonSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSetting setImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
    [buttonSetting setImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
    [buttonSetting sizeToFit];
    [buttonSetting addTarget:self action:@selector(onActionSettingClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemSetting = [[UIBarButtonItem alloc]initWithCustomView:buttonSetting];
    
    UIButton *buttonMoon = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMoon setImage:[UIImage imageNamed:@"mine-moon-icon"] forState:UIControlStateNormal];
    [buttonMoon setImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:UIControlStateHighlighted];
    [buttonMoon sizeToFit];
    [buttonMoon addTarget:self action:@selector(onActionMoonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemMoon = [[UIBarButtonItem alloc]initWithCustomView:buttonMoon];
    
    self.navigationItem.rightBarButtonItems = @[itemSetting,itemMoon];
}
- (void)onActionSettingClick
{
    WHLogFunc
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
