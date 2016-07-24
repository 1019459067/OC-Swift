//
//  WHSettingViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/12.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHSettingViewController.h"
#import "WHClearCacheCell.h"
#import "WHSettingCell.h"

@interface WHSettingViewController ()

@end


@implementation WHSettingViewController

static NSString * const WHClearCacheCellID = @"WHClearCacheCell";
static NSString * const WHSettingCellID = @"WHSettingCell";

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
    [self.tableView registerClass:[WHSettingCell class] forCellReuseIdentifier:WHSettingCellID];

}

#pragma mark - UITableViewData

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return [tableView dequeueReusableCellWithIdentifier:WHClearCacheCellID];
    }
    else
    {
        WHSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:WHSettingCellID];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"检查更新";
        }else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"给我们评分";
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"推送设置";
        }else if (indexPath.row == 4){
            cell.textLabel.text = @"关于我们";
        }
        return cell;
    }
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
