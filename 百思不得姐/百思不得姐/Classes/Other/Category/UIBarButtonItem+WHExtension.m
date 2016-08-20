//
//  UIBarButtonItem+WHExtension.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/12.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "UIBarButtonItem+WHExtension.h"

@implementation UIBarButtonItem (WHExtension)
+ (instancetype)itemWithImage:(NSString *)strImg hightImage:(NSString *)strHightImg action:(SEL)action addTarget:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:strImg] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:strHightImg] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}
@end
