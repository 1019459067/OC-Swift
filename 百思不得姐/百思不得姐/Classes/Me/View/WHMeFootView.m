//
//  WHMeFootView.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/24.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHMeFootView.h"
#import "AFNetworking.h"
#import "WHMeSquare.h"
#import "MJExtension.h"
#import "UIButton+WebCache.h"
#import "WHMeSquareButton.h"

@implementation WHMeFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"a"] = @"square";
        param[@"c"] = @"topic";
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *squares = [WHMeSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            [self createSquare:squares];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WHLogFunc
        }];
    }
    return self;
}
- (void)createSquare:(NSArray *)squares
{
    int iMaxCowsCount = 4;
    CGFloat btnW = self.wh_width/iMaxCowsCount;
    CGFloat btnH = btnW;
    
    for (int i = 0; i < squares.count; i++) {
        WHMeSquare *square = squares[i];
        // create Btn
        WHMeSquareButton *btn = [WHMeSquareButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(onActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        btn.wh_x = i % iMaxCowsCount * btnW;
        btn.wh_y = i / iMaxCowsCount * btnH;
        btn.wh_height = btnH;
        btn.wh_width = btnW;
        
        [btn setTitle:square.name forState:UIControlStateNormal];
        [btn sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"setup-head-default"]];
    }
    // set footer view max height
    self.wh_height = self.subviews.lastObject.wh_bottom;
    //
    UITableView *tableView = (UITableView *)self.superview;
    tableView.contentSize = CGSizeMake(0, self.wh_bottom);
}
- (void)onActionClicked:(WHMeSquareButton *)sender
{
    WHLogFunc
}
@end
