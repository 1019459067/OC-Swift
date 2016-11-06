//
//  WHLayer.m
//  Core Animation Demo
//
//  Created by 肖伟华 on 2016/11/6.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHLayer.h"

@implementation WHLayer
- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetRGBStrokeColor(ctx, 135.0/255.0, 232.0/255.0, 84.0/255.0, 1);
    CGContextSetRGBFillColor(ctx, 135.0/255.0, 232.0/255.0, 84.0/255.0, 1);
    
    // start point
    CGContextMoveToPoint(ctx, 94.5, 33.5);
    
    // star all points
    CGContextAddLineToPoint(ctx,104.02, 47.39);
    CGContextAddLineToPoint(ctx,120.18, 52.16);
    CGContextAddLineToPoint(ctx,109.91, 65.51);
    CGContextAddLineToPoint(ctx,110.37, 82.34);
    CGContextAddLineToPoint(ctx,94.5, 76.7);
    CGContextAddLineToPoint(ctx,78.63, 82.34);
    CGContextAddLineToPoint(ctx,79.09, 65.51);
    CGContextAddLineToPoint(ctx,68.82, 52.16);
    CGContextAddLineToPoint(ctx,84.98, 47.39);
    
    // add shadow
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[4] = {1,0,0,1};
    CGColorRef color = CGColorCreate(colorSpace, components);
    CGContextSetShadowWithColor(ctx, CGSizeMake(1, 1), 0.5, color);

    // close points
    CGContextClosePath(ctx);
    
    // draw point
    CGContextDrawPath(ctx, kCGPathFill);
    
    // release
    CGColorRelease(color);
    CGColorSpaceRelease(colorSpace);
}
@end
