//
//  WHView.m
//  Quartz 2D-Demo
//
//  Created by STMBP on 2016/11/4.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "WHView.h"

@implementation WHView

- (void)drawRect:(CGRect)rect
{
    [self drawLine2];
}
- (void)drawLine2
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 20, 50);
    CGContextAddLineToPoint(ctx, 20, 100);
    CGContextAddLineToPoint(ctx, 300, 100);
    
    [[UIColor redColor] setStroke];
    [[UIColor greenColor] setFill];
    CGContextSetLineWidth(ctx, 2.6);
    
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}
- (void)drawLine1
{
    /// 1.get context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /// 2.create path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 20, 50);
    CGPathAddLineToPoint(path, nil, 20, 100);
    CGPathAddLineToPoint(path, nil, 300, 100);
    CGContextAddLineToPoint(ctx, 20, 50);
    /// 3.add path
    CGContextAddPath(ctx, path);
    
    /// 4. set ctx status
    CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
    CGContextSetRGBFillColor(ctx, 0, 1, 0, 1);
    CGContextSetLineWidth(ctx, 2);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGFloat lengths[2] = {20,10};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    
    CGColorRef color = [UIColor grayColor].CGColor;
    CGContextSetShadowWithColor(ctx, CGSizeMake(2, 2), 0.8, color);
    
    /// 5.draw in ctx
    CGContextDrawPath(ctx, kCGPathEOFillStroke);
    
    /// 6.release path
    CGPathRelease(path);
}
@end
