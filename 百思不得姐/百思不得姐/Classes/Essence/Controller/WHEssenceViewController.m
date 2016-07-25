//
//  WHEssenceViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHEssenceViewController.h"
#import "WHTitleButton.h"
#import "WHAllViewController.h"
#import "WHVideoViewController.h"
#import "WHVoiceViewController.h"
#import "WHPictureViewController.h"
#import "WHWordViewController.h"

@interface WHEssenceViewController ()
@property (weak, nonatomic) WHTitleButton *selectedBtn;
@property (strong, nonatomic) UIView *indicatorView;
@end

@implementation WHEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildVCs];
    [self setupNav];
    [self setupScrollView];
    [self setupTitlesView];
}
- (void)setupChildVCs
{
    WHAllViewController *vc1 = [[WHAllViewController alloc]init];
    [self addChildViewController:vc1];

    WHVideoViewController *vc2 = [[WHVideoViewController alloc]init];
    [self addChildViewController:vc2];

    WHVoiceViewController *vc3 = [[WHVoiceViewController alloc]init];
    [self addChildViewController:vc3];

    WHPictureViewController *vc4 = [[WHPictureViewController alloc]init];
    [self addChildViewController:vc4];

    WHWordViewController *vc5 = [[WHWordViewController alloc]init];
    [self addChildViewController:vc5];
}
- (void)setupTitlesView
{
    UIView *viewTitles = [[UIView alloc]init];
    viewTitles.frame = CGRectMake(0, 64, self.view.wh_width, 35);
    viewTitles.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:viewTitles];
    
    //set titles
    NSArray *arrTitle = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    CGFloat btnW = viewTitles.wh_width/arrTitle.count;
    CGFloat btnH = viewTitles.wh_height;
    CGFloat btnY = 0;
    for (int i = 0 ; i < arrTitle.count; i++) {
        WHTitleButton *btn = [WHTitleButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(onActionTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [viewTitles addSubview:btn];
        
        CGFloat btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [btn setTitle:arrTitle[i] forState:UIControlStateNormal];
    }
    
    WHTitleButton *firstBtn = viewTitles.subviews.firstObject;
    
    //indicatorView
    self.indicatorView = [[UIView alloc]init];
    self.indicatorView.backgroundColor = [firstBtn titleColorForState:UIControlStateSelected];
    [viewTitles addSubview:self.indicatorView];
    self.indicatorView.wh_height = 1;
    self.indicatorView.wh_y = viewTitles.wh_height-self.indicatorView.wh_height;
    
    //calculate title label size at once
    [firstBtn.titleLabel sizeToFit];
    self.indicatorView.wh_width = firstBtn.titleLabel.wh_width;
    self.indicatorView.wh_centerX = firstBtn.wh_centerX;
    firstBtn.selected = YES;
    self.selectedBtn = firstBtn;
}
- (void)onActionTitleButton:(WHTitleButton *)sender
{
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    
    //set animation
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.wh_width = sender.titleLabel.wh_width;
        self.indicatorView.wh_centerX = sender.wh_centerX;
    }];
}
- (void)setupScrollView
{
    //不允许scrollView自动调整内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = WHRandomColor;
    [self.view addSubview:scrollView];
    
    //
    for (int i = 0 ; i < self.childViewControllers.count; i++)
    {
        UITableView *childView = (UITableView*)self.childViewControllers[i].view;
        childView.wh_x = scrollView.wh_width*i;
        childView.wh_y = 0;
        childView.wh_height = scrollView.wh_height;
        childView.backgroundColor = WHRandomColor;
        childView.contentInset = UIEdgeInsetsMake(64+35, 0, 49, 0);
        childView.scrollIndicatorInsets = childView.contentInset;
        [scrollView addSubview:childView];
    }
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.wh_width, 0);
    
}
- (void)setupNav
{
    self.view.backgroundColor = WHColorCommonBg;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" hightImag:@"MainTagSubIconClick" action:@selector(onActionTagClick) addTarget:self];
}
- (void)onActionTagClick
{
    WHLogFunc
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = WHRandomColor;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
