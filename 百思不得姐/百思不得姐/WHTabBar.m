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
    CGFloat fBtnW = self.frame.size.width / 5.;
    CGFloat fBtnH = self.frame.size.height ;
    
    NSInteger indexBtn = 0;
    
    for (UIView *viewSub in self.subviews) {
        if (viewSub.class != NSClassFromString(@"UITabBarButton")) continue;
        
        fBtnX = indexBtn * fBtnW;
        if (indexBtn >= 2) {
            fBtnX += fBtnW;
        }
        viewSub.frame = CGRectMake(fBtnX, fBtnY, fBtnW, fBtnH);
        indexBtn ++ ;
    }
    // add button
    self.btnPublish.frame = CGRectMake(0, 0, fBtnW, fBtnH);
    self.btnPublish.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    WHLogFunc
}


- (void)onActionPublish
{
    WHLogFunc;
}
@end
