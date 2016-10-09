
//
//  WHTopWindow.m
//  百思不得姐
//
//  Created by 肖伟华 on 2016/10/9.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHTopWindow.h"

static UIWindow *window_;

@implementation WHTopWindow
+ (void)show
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        window_ = [[UIWindow alloc]init];
        window_.frame = [UIApplication sharedApplication].statusBarFrame;
        window_.windowLevel = UIWindowLevelAlert;
        window_.backgroundColor = [UIColor clearColor];
        window_.hidden = NO;
        
        [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapWindowTop)]];
    });
}

+ (void)onTapWindowTop
{
    [self findScrollViewInView:[UIApplication sharedApplication].keyWindow];
}
+ (void)findScrollViewInView:(UIView *)view
{
    for (UIView *subView in view.subviews)
    {
        [self findScrollViewInView:subView];
    }
    
    if (![view isKindOfClass:[UIScrollView class]]) return;
    
    //判断view是否和window有重叠
    if (![view intersectsRectWithView:[UIApplication sharedApplication].keyWindow]) return;
    
    UIScrollView *scrollView = (UIScrollView *)view;
    CGPoint offset = scrollView.contentOffset;
    offset.y = -scrollView.contentInset.top;
    [scrollView setContentOffset:offset animated:YES];
}
@end
