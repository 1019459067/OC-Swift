//
//  WHMeViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHMeViewController.h"
#import "WHSettingViewController.h"
#import "WHMeCell.h"
#import "WHMeFootView.h"

@interface WHMeViewController ()

@end

@implementation WHMeViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupNav];
}
- (void)setupTableView
{
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = WHMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(WHMargin-35, 0, 0, 0);
    self.tableView.backgroundColor = WHColorCommonBg;
    
//    WHMeFootView *viewFoot = [[WHMeFootView alloc]init];
    self.tableView.tableFooterView = [[WHMeFootView alloc]init];
}
- (void)setupNav
{
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *itemSetting = [UIBarButtonItem itemWithImage:@"mine-setting-icon" hightImage:@"mine-setting-icon-click" action:@selector(onActionSettingClick) addTarget:self];
    
    UIBarButtonItem *itemMoon = [UIBarButtonItem itemWithImage:@"mine-moon-icon" hightImage:@"mine-moon-icon-click" action:@selector(onActionMoonClick) addTarget:self];
    
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

#pragma mark - UITableViewData

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"WHMeViewControllercell";
    WHMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[WHMeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    }else
    {
        cell.textLabel.text = @"离线下载";
        cell.imageView.image = nil;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)return 200;
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
