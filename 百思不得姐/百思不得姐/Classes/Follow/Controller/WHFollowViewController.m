//
//  WHFollowViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHFollowViewController.h"
#import "WHRecommendFollowViewController.h"

@interface WHFollowViewController ()

@end

@implementation WHFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHColorCommonBg;
    self.navigationItem.title = @"我的关注";
    WHLogFunc
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" hightImag:@"friendsRecommentIcon-click" action:@selector(onActionFriendClick) addTarget:self];
}
- (void)onActionFriendClick
{
    WHRecommendFollowViewController *vc = [[WHRecommendFollowViewController alloc]init];
    vc.view.backgroundColor = WHRandomColor;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
