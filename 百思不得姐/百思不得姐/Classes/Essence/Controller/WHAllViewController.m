//
//  WHAllViewController.m
//  百思不得姐
//
//  Created by STMBP on 16/7/25.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHAllViewController.h"
#import "AFNetworking.h"
#import "WHTopic.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "WHRefreshHeader.h"

@interface WHAllViewController ()
@property (strong, nonatomic) NSArray *topics;
@end

@implementation WHAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WHLogFunc
    
    self.tableView.contentInset = UIEdgeInsetsMake(64+35, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    //
    [self setupRefresh];
//    [self loadNewTopics];
}
- (void)setupRefresh
{
    self.tableView.mj_header = [WHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 数据加载
- (void)loadNewTopics
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"a"] = @"list";
    param[@"c"] = @"data";

    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.topics = [WHTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        [self createSquare:squares];
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
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    WHTopic *topic = self.topics[indexPath.row];
    cell.textLabel.text = topic.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    return cell;
}
@end
