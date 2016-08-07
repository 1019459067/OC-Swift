//
//  UIView+WHExtension.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "UIView+WHExtension.h"

@implementation UIView (WHExtension)
- (CGSize)wh_size
{
    return self.frame.size;
}
- (void)setWh_size:(CGSize)wh_size
{
    CGRect frame = self.frame;
    frame.size = wh_size;
    self.frame = frame;
}


- (CGFloat)wh_width
{
    return self.frame.size.width;
}
- (CGFloat)wh_height
{
    return self.frame.size.height;
}
- (void)setWh_width:(CGFloat)wh_width
{
    CGRect frame = self.frame;
    frame.size.width = wh_width;
    self.frame = frame;
}
- (void)setWh_height:(CGFloat)wh_height
{
    CGRect frame = self.frame;
    frame.size.height = wh_height;
    self.frame = frame;
}

- (CGFloat)wh_x
{
    return self.frame.origin.x;
}
- (void)setWh_x:(CGFloat)wh_x
{
    CGRect frame = self.frame;
    frame.origin.x = wh_x;
    self.frame = frame;
}
- (CGFloat)wh_y
{
    return self.frame.origin.y;
}
- (void)setWh_y:(CGFloat)wh_y
{
    CGRect frame = self.frame;
    frame.origin.y = wh_y;
    self.frame = frame;
}

- (CGFloat)wh_centerX
{
    return self.center.x;
}
- (void)setWh_centerX:(CGFloat)wh_centerX
{
    CGPoint center = self.center;
    center.x = wh_centerX;
    self.center = center;
}
- (CGFloat)wh_centerY
{
    return self.center.y;
}
- (void)setWh_centerY:(CGFloat)wh_centerY
{
    CGPoint center = self.center;
    center.y = wh_centerY;
    self.center = center;
}


- (void)setWh_right:(CGFloat)wh_right
{
    self.wh_x = wh_right- self.wh_width;
}
- (void)setWh_bottom:(CGFloat)wh_bottom
{
    self.wh_y = wh_bottom- self.wh_height;
}
- (CGFloat)wh_right
{
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)wh_bottom
{
    return CGRectGetMaxY(self.frame);
}

+ (instancetype)wh_viewFromXib
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
@end
