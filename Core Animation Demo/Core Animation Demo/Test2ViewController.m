//
//  Test2ViewController.m
//  Core Animation Demo
//
//  Created by 肖伟华 on 2016/11/6.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "Test2ViewController.h"
#define PHOTO_HEIGHT 150

@interface Test2ViewController ()<CALayerDelegate>

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    layer.position = CGPointMake(self.view.frame.size.width/2., self.view.frame.size.height/2.);
    layer.borderWidth = 2;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.cornerRadius = PHOTO_HEIGHT/2;
    layer.shadowOpacity = 0.8;
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.masksToBounds = YES;
    [self.view.layer addSublayer:layer];
    
    layer.delegate = self;
    [layer setNeedsDisplay];
}
#pragma mark - 绘制图形、图像到图层,通过图层代理drawLayer: inContext:方法绘制
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
    
    UIImage *img = [UIImage imageNamed:@"06.jpg"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), img.CGImage);
    
    CGContextRestoreGState(ctx);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
