//
//  WHImgView.m
//  Quartz 2D-Demo
//
//  Created by 肖伟华 on 2016/11/5.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "WHImgView.h"

@implementation WHImgView

- (void)drawRect:(CGRect)rect
{
    [self drawImageByUIKitWithContext_2:UIGraphicsGetCurrentContext()];
}
#pragma mark - 图形上下文形变
- (void)drawImageByUIKitWithContext_2:(CGContextRef)context
{
    UIImage *img = [UIImage imageNamed:@"07.jpg"];
 
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -self.frame.size.height);
    CGContextDrawImage(context, CGRectMake(40, 50, self.frame.size.width-40*2, self.frame.size.height-50*2), img.CGImage);
    
    CGContextRestoreGState(context);
}
- (void)drawImageByUIKitWithContext:(CGContextRef)context
{
    UIImage *img = [UIImage imageNamed:@"07.jpg"];

    CGContextDrawImage(context, CGRectMake(40, 50, self.frame.size.width-40*2, self.frame.size.height-50*2), img.CGImage);
}
- (void)drawImageWithContext:(CGContextRef)context
{
    //save original status
    CGContextSaveGState(context);
    
    //deformation
    CGContextTranslateCTM(context, 100, 0);
    CGContextScaleCTM(context, 0.8, 0.8);
    CGContextRotateCTM(context, M_PI_4/4);
    
    UIImage *img = [UIImage imageNamed:@"07.jpg"];
    [img drawInRect:CGRectMake(0, 50, 200, 300)];
    
    // recover status
    CGContextRestoreGState(context);
}
@end
