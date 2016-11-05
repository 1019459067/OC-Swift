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
    [self drawBackgroundByColoredPatternWithContext:context];
}
#pragma mark - 有颜色填充模式
#define TILE_SIZE 20
- (void)drawBackgroundByColoredPatternWithContext:(CGContextRef)context
{
    //模式填充颜色空间,注意对于有颜色填充模式，这里传NULL
    CGColorSpaceRef colorSpace = CGColorSpaceCreatePattern(NULL);
    //将填充色颜色空间设置为模式填充的颜色空间
    CGContextSetFillColorSpace(context, colorSpace);
    
    //填充模式回调函数结构体
    CGPatternCallbacks callBack = {
        0,&drawColoredTile,NULL
    };
    
    /*填充模式
     info://传递给callback的参数
     bounds:瓷砖大小
     matrix:形变
     xStep:瓷砖横向间距
     yStep:瓷砖纵向间距
     tiling:贴砖的方法
     isClored:绘制的瓷砖是否已经指定了颜色(对于有颜色瓷砖此处指定位true)
     callbacks:回调函数
     */
    CGPatternRef pattern = CGPatternCreate(NULL, CGRectMake(0, 0, TILE_SIZE*2, TILE_SIZE*2), CGAffineTransformIdentity, TILE_SIZE*2+5, TILE_SIZE*2+5, kCGPatternTilingNoDistortion, YES, &callBack);
    
    CGFloat apla = 1;
    //注意最后一个参数对于有颜色瓷砖指定为透明度的参数地址，对于无颜色瓷砖则指定当前颜色空间对应的颜色数组
    CGContextSetFillPattern(context, pattern, &apla);
    
    //大小尺寸
    UIRectFill(self.frame);
    
    CGPatternRelease(pattern);
    CGColorSpaceRelease(colorSpace);
    
}
void drawColoredTile(void *info, CGContextRef context)
{
    //有颜色填充，这里设置填充色
    CGContextSetRGBFillColor(context, 254.0/255.0, 52.0/255.0, 90.0/255.0, 1);
    CGContextFillRect(context, CGRectMake(0, 0, TILE_SIZE, TILE_SIZE));
    CGContextFillRect(context, CGRectMake(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE));
}
#pragma mark - 叠加模式
- (void)drawRectByUIKitWithContext:(CGContextRef)context
{
    CGRect rect= CGRectMake(0, 130.0, 320.0, 50.0);
    CGRect rect1= CGRectMake(0, 390.0, 320.0, 50.0);
    
    
    CGRect rect2=CGRectMake(20, 50.0, 10.0, 250.0);
    CGRect rect3=CGRectMake(40.0, 50.0, 10.0, 250.0);
    CGRect rect4=CGRectMake(60.0, 50.0, 10.0, 250.0);
    CGRect rect5=CGRectMake(80.0, 50.0, 10.0, 250.0);
    CGRect rect6=CGRectMake(100.0, 50.0, 10.0, 250.0);
    CGRect rect7=CGRectMake(120.0, 50.0, 10.0, 250.0);
    CGRect rect8=CGRectMake(140.0, 50.0, 10.0, 250.0);
    CGRect rect9=CGRectMake(160.0, 50.0, 10.0, 250.0);
    CGRect rect10=CGRectMake(180.0, 50.0, 10.0, 250.0);
    CGRect rect11=CGRectMake(200.0, 50.0, 10.0, 250.0);
    CGRect rect12=CGRectMake(220.0, 50.0, 10.0, 250.0);
    CGRect rect13=CGRectMake(240.0, 50.0, 10.0, 250.0);
    CGRect rect14=CGRectMake(260.0, 50.0, 10.0, 250.0);
    CGRect rect15=CGRectMake(280.0, 50.0, 10.0, 250.0);
    
    CGRect rect16=CGRectMake(30.0, 310.0, 10.0, 250.0);
    CGRect rect17=CGRectMake(50.0, 310.0, 10.0, 250.0);
    CGRect rect18=CGRectMake(70.0, 310.0, 10.0, 250.0);
    CGRect rect19=CGRectMake(90.0, 310.0, 10.0, 250.0);
    CGRect rect20=CGRectMake(110.0, 310.0, 10.0, 250.0);
    CGRect rect21=CGRectMake(130.0, 310.0, 10.0, 250.0);
    CGRect rect22=CGRectMake(150.0, 310.0, 10.0, 250.0);
    CGRect rect23=CGRectMake(170.0, 310.0, 10.0, 250.0);
    CGRect rect24=CGRectMake(190.0, 310.0, 10.0, 250.0);
    CGRect rect25=CGRectMake(210.0, 310.0, 10.0, 250.0);
    CGRect rect26=CGRectMake(230.0, 310.0, 10.0, 250.0);
    CGRect rect27=CGRectMake(250.0, 310.0, 10.0, 250.0);
    CGRect rect28=CGRectMake(270.0, 310.0, 10.0, 250.0);
    CGRect rect29=CGRectMake(290.0, 310.0, 10.0, 250.0);
    
    
    [[UIColor yellowColor]set];
    UIRectFill(rect);
    
    [[UIColor greenColor]setFill];
    UIRectFill(rect1);
    
    [[UIColor redColor]setFill];
    UIRectFillUsingBlendMode(rect2, kCGBlendModeClear);
    UIRectFillUsingBlendMode(rect3, kCGBlendModeColor);
    UIRectFillUsingBlendMode(rect4, kCGBlendModeColorBurn);
    UIRectFillUsingBlendMode(rect5, kCGBlendModeColorDodge);
    UIRectFillUsingBlendMode(rect6, kCGBlendModeCopy);
    UIRectFillUsingBlendMode(rect7, kCGBlendModeDarken);
    UIRectFillUsingBlendMode(rect8, kCGBlendModeDestinationAtop);
    UIRectFillUsingBlendMode(rect9, kCGBlendModeDestinationIn);
    UIRectFillUsingBlendMode(rect10, kCGBlendModeDestinationOut);
    UIRectFillUsingBlendMode(rect11, kCGBlendModeDestinationOver);
    UIRectFillUsingBlendMode(rect12, kCGBlendModeDifference);
    UIRectFillUsingBlendMode(rect13, kCGBlendModeExclusion);
    UIRectFillUsingBlendMode(rect14, kCGBlendModeHardLight);
    UIRectFillUsingBlendMode(rect15, kCGBlendModeHue);
    UIRectFillUsingBlendMode(rect16, kCGBlendModeLighten);
    
    UIRectFillUsingBlendMode(rect17, kCGBlendModeLuminosity);
    UIRectFillUsingBlendMode(rect18, kCGBlendModeMultiply);
    UIRectFillUsingBlendMode(rect19, kCGBlendModeNormal);
    UIRectFillUsingBlendMode(rect20, kCGBlendModeOverlay);
    UIRectFillUsingBlendMode(rect21, kCGBlendModePlusDarker);
    UIRectFillUsingBlendMode(rect22, kCGBlendModePlusLighter);
    UIRectFillUsingBlendMode(rect23, kCGBlendModeSaturation);
    UIRectFillUsingBlendMode(rect24, kCGBlendModeScreen);
    UIRectFillUsingBlendMode(rect25, kCGBlendModeSoftLight);
    UIRectFillUsingBlendMode(rect26, kCGBlendModeSourceAtop);
    UIRectFillUsingBlendMode(rect27, kCGBlendModeSourceIn);
    UIRectFillUsingBlendMode(rect28, kCGBlendModeSourceOut);
    UIRectFillUsingBlendMode(rect29, kCGBlendModeXOR);
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
