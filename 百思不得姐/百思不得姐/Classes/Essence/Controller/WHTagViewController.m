//
//  WHTagViewController.m
//  百思不得姐
//
//  Created by XWH on 15/9/1.
//  Copyright (c) 2016年 XWH. All rights reserved.
//

#import "WHTagViewController.h"
#import "WHTagCell.h"
#import "WHTag.h"

@interface WHTagViewController ()
/** 所有的标签数据（里面存放的都是WHTag模型） */
@property (nonatomic, strong) NSArray *tags;
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
@end

@implementation WHTagViewController

/** cell的循环利用标识 */
static NSString * const WHTagCellId = @"tag";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐标签";
    
    [self setupTable];
    
    [self loadTags];
}

- (void)setupTable
{
    self.tableView.backgroundColor = WHColorCommonBg;
    // 设置行高
    self.tableView.rowHeight = 70;
    
    // 去掉系统自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WHTagCell class]) bundle:nil] forCellReuseIdentifier:WHTagCellId];
}

- (void)loadTags
{
    [SVProgressHUD show];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    WHWeakSelf;
    [self.manager GET:WHCommonURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        WHLog(@"downloadProgress :%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
            return;
        }
        
        // responseObject -> weakSelf.tags
        weakSelf.tags = [WHTag mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == NSURLErrorCancelled) return;
        
        if (error.code == NSURLErrorTimedOut) {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据超时,请稍后再试!"];
        } else {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
        }
    }];
}

- (void)dealloc
{
    [self.manager invalidateSessionCancelingTasks:YES];
    
    [SVProgressHUD dismiss];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}

/**
 * 返回indexPath位置对应的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHTagCell *cell = [tableView dequeueReusableCellWithIdentifier:WHTagCellId];
    
    cell.tagModel = self.tags[indexPath.row];
    
    return cell;
}
@end
