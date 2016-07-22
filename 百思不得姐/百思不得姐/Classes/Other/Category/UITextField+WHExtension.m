//
//  UITextField+WHExtension.m
//  百思不得姐
//
//  Created by STMBP on 16/7/22.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "UITextField+WHExtension.h"
static  NSString * const WHPlaceHolderString = @"placeholderLabel.textColor";

@implementation UITextField (WHExtension)
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    //设置占位默认文字
    NSString *oldPlaceholder = self.placeholder;
    self.placeholder = @" ";
    self.placeholder = oldPlaceholder;
    
    //设置占位默认颜色
    if (placeholderColor == nil)
    {
        placeholderColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    }
    [self setValue:placeholderColor forKeyPath:WHPlaceHolderString];
}
- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:WHPlaceHolderString];
}
@end
