//
//  WHSettingViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/12.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHSettingViewController.h"
#import "WHClearCacheCell.h"

@interface WHSettingViewController ()

@end


@implementation WHSettingViewController

static NSString * const WHClearCacheCellID = @"WHClearCacheCell";

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = WHColorCommonBg;
    
    //
    [self.tableView registerClass:[WHClearCacheCell class] forCellReuseIdentifier:WHClearCacheCellID];
}

#pragma mark - UITableViewData

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHClearCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:WHClearCacheCellID];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHLogFunc
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
