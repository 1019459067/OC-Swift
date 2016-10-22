//
//  WHTabBar.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHTabBar.h"

@interface WHTabBar ()
@property (strong, nonatomic) UIButton *btnPublish;
@end

@implementation WHTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
    }
    return self;
}
- (UIButton *)btnPublish
{
    if (!_btnPublish) {
        _btnPublish = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPublish setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [_btnPublish setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [_btnPublish addTarget:self action:@selector(onActionPublish) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnPublish];
    }
    return _btnPublish;
}
/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat fBtnX = 0;
    CGFloat fBtnY = 0;
    CGFloat fBtnW = self.wh_width / 5.;
    CGFloat fBtnH = self.wh_height ;
    
    NSInteger indexBtn = 0;
    
    for (UIView *viewSub in self.subviews) {
        if (viewSub.class != NSClassFromString(@"UITabBarButton")) continue;
        
        fBtnX = indexBtn * fBtnW;
        if (indexBtn >= 2) {
            fBtnX += fBtnW;
        }
        viewSub.frame = CGRectMake(fBtnX, fBtnY, fBtnW, fBtnH);
        indexBtn ++ ;
        
//        UIControl *controlTabbar = (UIControl *)viewSub;
//        [controlTabbar addTarget:self action:@selector(onActionTabbarBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    // add button
    self.btnPublish.wh_width = fBtnW;
    self.btnPublish.wh_height = fBtnH;
    self.btnPublish.wh_centerX = self.wh_width * 0.5;
    self.btnPublish.wh_centerY = self.wh_height * 0.5;
}

//- (void)onActionTabbarBtn
//{
//    WHLogFunc;
//}

- (void)onActionPublish
{
    WHLogFunc;
}
@end
