//
//  WHColorView.m
//  Quartz 2D-Demo
//
//  Created by 肖伟华 on 2016/11/5.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "WHColorView.h"

@implementation WHColorView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRectLinerGradientWithContext:context];
}
#pragma mark - 扩展--渐变填充
- (void)drawRectLinerGradientWithContext:(CGContextRef)context
{
    CGRect rect = CGRectMake(20, 50, self.frame.size.width-20*2, 300);
    UIRectClip(rect);
 
    const CGFloat components[12] = {
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,
        1,1.0,1.0,1.0,1.0
    };
    const CGFloat locations[3] = {0,0.3,1.0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpace, components, locations, 3);
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(20, 50), CGPointMake(self.frame.size.width, self.frame.size.height), kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpace);
}
#pragma mark - 径向渐变
- (void)drawRadiusGradientWithContext:(CGContextRef)context
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    const CGFloat components[12] = {
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,
        1,1.0,1.0,1.0,1.0
    };
    const CGFloat locations[3] = {0,0.3,1.0};
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpace, components, locations, 3);
    CGContextDrawRadialGradient(context, gradientRef, self.center, 0, self.center, self.frame.size.width/2-30, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpace);
}
#pragma mark - 线性渐变
- (void)drawLinerGradientWithContext:(CGContextRef)context
{
    // use RGB space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    const CGFloat components[12] = {
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,
        1,1.0,1.0,1.0,1.0
    };
    const CGFloat locations[3] = {0,0.3,1.0};
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpace, components, locations, 3);
    
    CGContextDrawLinearGradient(context, gradientRef, CGPointZero, CGPointMake(self.frame.size.width, self.frame.size.height), kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpace);
}
@end
