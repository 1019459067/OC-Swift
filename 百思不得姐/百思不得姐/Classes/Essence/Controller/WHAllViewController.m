//
//  WHAllViewController.m
//  百思不得姐
//
//  Created by STMBP on 16/7/25.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHAllViewController.h"
#import "WHHTTPSessionManager.h"
#import "WHTopic.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "WHRefreshHeader.h"
#import "WHRefreshFooter.h"
#import "WHTopicCell.h"

static NSString * const WHTopicCellID = @"WHTopicCell";

@interface WHAllViewController ()
@property (strong, nonatomic) NSMutableArray<WHTopic *> *topics;
/** 用来加载下一页数据 */
@property (copy, nonatomic) NSString *maxtime;
@property (strong, nonatomic) WHHTTPSessionManager *mgr;
@end

@implementation WHAllViewController
- (AFHTTPSessionManager *)mgr
{
    if (!_mgr) {
        _mgr = [WHHTTPSessionManager manager];
    }
    return _mgr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupRefresh];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WHTopicCell class]) bundle:nil] forCellReuseIdentifier:WHTopicCellID];
}
- (void)setupTableView
{
    self.tableView.contentInset = UIEdgeInsetsMake(64+35, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = WHColorCommonBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 250;
}
- (void)setupRefresh
{
    self.tableView.mj_header = [WHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [WHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}
#pragma mark - 数据加载
- (void)loadMoreTopics
{
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"a"] = @"list";
    param[@"c"] = @"data";
    param[@"maxtime"] = self.maxtime;


    [self.mgr GET:WHCommonURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.maxtime = responseObject[@"info"][@"maxtime"];
        [self.topics addObjectsFromArray:[WHTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WHLogFunc
        [self.tableView.mj_footer endRefreshing];
    }];

}
- (void)loadNewTopics
{
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"a"] = @"list";
    param[@"c"] = @"data";

    [self.mgr GET:WHCommonURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        self.topics = [WHTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        for (int i = 0 ; i< self.topics.count; i++) {
            if (self.topics[i].top_cmt.count) {
                NSLog(@"=== %d",i);
            }
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WHLogFunc
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:WHTopicCellID];
    cell.topic = self.topics[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    WHTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.wh_height -= 10;
}
@end
