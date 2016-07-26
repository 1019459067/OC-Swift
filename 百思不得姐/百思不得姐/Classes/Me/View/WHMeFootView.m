//
//  WHMeFootView.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/24.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHMeFootView.h"
#import "WHHTTPSessionManager.h"
#import "WHMeSquareButton.h"
#import "MJExtension.h"
#import "WHMeSquare.h"
#import "WHWebViewController.h"
#import <SafariServices/SafariServices.h>

@interface WHMeFootView ()

@end

@implementation WHMeFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"a"] = @"square";
        param[@"c"] = @"topic";
    
        [[WHHTTPSessionManager manager] GET:WHCommonURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
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
    
    for (int i = 0; i < squares.count; i++)
    {
        // create Btn
        WHMeSquareButton *btn = [WHMeSquareButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(onActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        btn.wh_x = i % iMaxCowsCount * btnW;
        btn.wh_y = i / iMaxCowsCount * btnH;
        btn.wh_height = btnH;
        btn.wh_width = btnW;
        
        btn.square = squares[i];
    }
    // set footer view max height
    self.wh_height = self.subviews.lastObject.wh_bottom;
    //
    UITableView *tableView = (UITableView *)self.superview;
//    tableView.contentSize = CGSizeMake(0, self.wh_bottom);//is exist bug
    tableView.tableFooterView = self;
    [tableView reloadData];
}
- (void)onActionClicked:(WHMeSquareButton *)sender
{
    NSString *url = sender.square.url;
    if ([url hasPrefix:@"http://"])//use web url load
    {
        WHWebViewController *vc = [[WHWebViewController alloc]init];
        vc.url = url;
        vc.navigationItem.title = sender.currentTitle;
        //get navigation
        UITabBarController *tabVC = (UITabBarController*)self.window.rootViewController;
        UINavigationController *nav = tabVC.selectedViewController;
        [nav pushViewController:vc animated:YES];
    }
    else if([url hasPrefix:@"mod://"])
    {
        WHLog(@"跳转 mod://");
    }else
    {
        WHLog(@"跳转 其他");
    }
    NSLog(@"== %@",url);
}
@end
