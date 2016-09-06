//
//  WHCommentViewController.m
//  百思不得姐
//
//  Created by XWH on 16/8/20.
//  Copyright (c) 2015年 XWH. All rights reserved.
//

#import "WHCommentViewController.h"
#import "WHTopicCell.h"
#import "WHCommentCell.h"
#import "WHTopic.h"
#import "WHComment.h"
#import "WHCommentHeaderView.h"
#import "WHUser.h"

@interface WHCommentViewController () <UITableViewDelegate, UITableViewDataSource>
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 暂时存储：最热评论 */
@property (nonatomic, strong) WHComment *topCommentSave;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论（所有的评论数据） */
@property (nonatomic, strong) NSMutableArray *latestComments;

// 属性名最好不要以new开头
//@property (nonatomic, strong) NSMutableArray *newComments;

/** 写方法声明的目的是为了使用点语法提示 */
- (WHComment *)selectedComment;
@end

@implementation WHCommentViewController

#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 初始化

static NSString * const WHCommentCellId = @"comment";
static NSString * const WHHeaderId = @"header";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" hightImage:@"comment_nav_item_share_icon_click" action:nil addTarget:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setupTable];
    
    [self setupRefresh];
}

- (void)setupTable
{
    self.tableView.backgroundColor = WHColorCommonBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WHCommentCell class]) bundle:nil] forCellReuseIdentifier:WHCommentCellId];
    [self.tableView registerClass:[WHCommentHeaderView class] forHeaderFooterViewReuseIdentifier:WHHeaderId];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 处理模型数据
    if (self.topic.top_cmt)
    {
        self.topCommentSave = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        self.topic.cellHeight = 0;
    }

    WHTopicCell *cell = [WHTopicCell wh_viewFromXib];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, WH_ScreenW, self.topic.cellHeight);

    // 设置header
    UIView *header = [[UIView alloc] init];
    header.wh_height = cell.wh_height + 2 * WHMargin;
    [header addSubview:cell];
    
    self.tableView.tableHeaderView = header;
}

- (void)setupRefresh
{
    self.tableView.mj_header = [WHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [WHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.topCommentSave)
    {
        self.topic.top_cmt = self.topCommentSave;
        self.topic.cellHeight = 0;
    }
}

#pragma mark - 加载评论数据
- (void)loadNewComments
{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @1;
    
    // 发送请求
    WHWeakSelf;
    [self.manager GET:WHCommonURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            return;
        }
        
        // 最热评论
        weakSelf.hotComments = [WHComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        weakSelf.latestComments = [WHComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
            weakSelf.tableView.mj_footer.hidden = YES;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreComments
{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"lastcid"] = [self.latestComments.lastObject ID];
    
    // 发送请求
    WHWeakSelf;
    [self.manager GET:WHCommonURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WHWriteToPlist(responseObject, @"comment_more");
        // 最新评论
        NSArray *newComments = [WHComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        // 刷新表格
        [weakSelf.tableView reloadData];
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue])
        {
            weakSelf.tableView.mj_footer.hidden = YES;
        } else { // 应该还会有下一页数据
            // 结束刷新(恢复到普通状态，仍旧可以继续刷新)
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

}

#pragma mark - 监听
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    self.bottomSpace.constant = WH_ScreenH - [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hotComments.count) return 2;
    if (self.latestComments.count) return 1;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.hotComments.count) {
        return self.hotComments.count;
    }
    
    return self.latestComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:WHCommentCellId];
    
    NSArray *comments = self.latestComments;
    if (indexPath.section == 0 && self.hotComments.count)
    {
        comments = self.hotComments;
    }
    cell.comment = comments[indexPath.row];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WHCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WHHeaderId];
    if (section == 0 && self.hotComments.count)
    {
        header.text = @"最热评论";
    } else {
        header.text = @"最新评论";
    }

    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    // 设置菜单内容
    menu.menuItems = @[
                       [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)],
                       [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)],
                       [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)]
                       ];
    
    // 显示位置
    CGRect rect = CGRectMake(0, cell.wh_height * 0.5, cell.wh_width, 10);
    [menu setTargetRect:rect inView:cell];
    
    // 显示出来
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - 获得当前选中的评论
- (WHComment *)selectedComment
{
    // 获得被选中的cell的行号
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    NSInteger row = indexPath.row;
    
    // 获得评论数据
    NSArray *comments = self.latestComments;
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    }
    
    return comments[row];
}

#pragma mark - UIMenuController处理
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (!self.isFirstResponder) { // 文本框弹出键盘, 文本框才是第一响应者
        if (action == @selector(ding:)
            || action == @selector(reply:)
            || action == @selector(warn:)) return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (void)ding:(UIMenuController *)menu
{
    WHLog(@"ding - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}

- (void)reply:(UIMenuController *)menu
{
    WHLog(@"reply - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}

- (void)warn:(UIMenuController *)menu
{
    WHLog(@"warn - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}
@end
