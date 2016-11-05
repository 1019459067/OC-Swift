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
    [self drawImgWithContext:UIGraphicsGetCurrentContext()];
}
#pragma mark - 图片绘制
- (void)drawImgWithContext:(CGContextRef)context
{
    UIImage *img = [UIImage imageNamed:@"07.jpg"];
    
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeMultiply alpha:1];
}
#pragma mark - 文字绘制
- (void)drawTextWithContext:(CGContextRef)context
{
    NSString *str = @"1019459067";
    CGRect rect = CGRectMake(20, 50, self.frame.size.width-20*2, self.frame.size.height-50);
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    attri[NSBackgroundColorAttributeName] = [UIColor orangeColor];
    attri[NSForegroundColorAttributeName] = [UIColor redColor];
    
    NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init];//段落样式
    style.alignment = NSTextAlignmentCenter;
    attri[NSParagraphStyleAttributeName] = style;
    [str drawInRect:rect withAttributes:attri];
}
#pragma mark - 绘制贝塞尔曲线
- (void)drawCurveWithContext:(CGContextRef)context
{
    // start point one
    CGContextMoveToPoint(context, 20, 100);
    CGContextAddQuadCurveToPoint(context, 160, 0, 300, 100);
    
    // start point two
    CGContextMoveToPoint(context, 20, 500);
    CGContextAddCurveToPoint(context, 80, 300, 240, 500, 300, 300);

    [[UIColor yellowColor]setFill];
    [[UIColor redColor]setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}
#pragma mark - 绘制圆弧
- (void)drawArcWithContext:(CGContextRef)context
{
    /*添加弧形对象
     x:中心点x坐标
     y:中心点y坐标
     radius:半径
     startAngle:起始弧度
     endAngle:终止弧度
     closewise:是否逆时针绘制，0则顺时针绘制
     */
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2-30, 0, M_PI_2, 1);
    [[UIColor redColor]set];
    
    CGContextDrawPath(context, kCGPathFill);
}
#pragma mark - 绘制椭圆
- (void)drawEllipseWithContext:(CGContextRef)context
{
    CGRect rect = CGRectMake(20, 50, self.frame.size.width-20*2, self.frame.size.width-20*2);
    CGContextAddEllipseInRect(context, rect);
    [[UIColor lightGrayColor]set];
    
    CGContextDrawPath(context, kCGPathEOFill);
}
#pragma mark - 绘制矩形（利用UIKit的封装方法）
- (void)drawRectByUIKitWithContext:(CGContextRef)context
{
    CGRect rect = CGRectMake(20, 150, self.frame.size.width-20*2, 50.0);
    CGRect rect2 = CGRectMake(20, 250, self.frame.size.width-20*2, 50.0);

    [[UIColor yellowColor]setFill];
    UIRectFill(rect);//绘制矩形（只有填充）
    
    [[UIColor redColor]setStroke];
    UIRectFrame(rect2);//绘制矩形(只有边框)
}
#pragma mark - 绘制矩形
- (void)drawRectWithContext:(CGContextRef)context
{
    // 添加对象
    CGRect rect = CGRectMake(20, 50, self.frame.size.width-20*2, 50.0);
    CGContextAddRect(context, rect);
    
    // 添加属性
    [[UIColor  blueColor]set];
    CGContextSetLineWidth(context, 2);
    
    // 绘制
    CGContextDrawPath(context, kCGPathFillStroke);
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
