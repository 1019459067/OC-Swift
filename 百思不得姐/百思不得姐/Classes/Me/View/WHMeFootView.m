//
//  WHMeFootView.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/24.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHMeFootView.h"
#import "AFNetworking.h"
#import "WHMeSquareButton.h"
#import "MJExtension.h"
#import "WHMeSquare.h"

@interface WHMeFootView ()
//@property (strong, nonatomic) NSMutableDictionary<NSString *,WHMeSquare *> *allSquares;
@end
@implementation WHMeFootView
//- (NSMutableDictionary<NSString *,WHMeSquare *> *)allSquares
//{
//    if (!_allSquares) {
//        _allSquares = [NSMutableDictionary dictionary];
//    }
//    return _allSquares;
//}
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
//        self.allSquares[square.name] = square;
        
        // create Btn
        WHMeSquareButton *btn = [WHMeSquareButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(onActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        btn.wh_x = i % iMaxCowsCount * btnW;
        btn.wh_y = i / iMaxCowsCount * btnH;
        btn.wh_height = btnH;
        btn.wh_width = btnW;
        btn.square = square;

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
    WHMeSquare *square = sender.square;//self.allSquares[sender.currentTitle];
    if ([square.url hasPrefix:@"http://"])//use web url load
    {
        
    }
    else if([square.url hasPrefix:@"mod://"])
    {
        WHLog(@"跳转 mod://");
    }else
    {
        WHLog(@"跳转 其他");
    }
    NSLog(@"== %@",square.url);
}
@end
