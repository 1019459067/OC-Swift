//
//  Test1ViewController.m
//  Core Animation Demo
//
//  Created by 肖伟华 on 2016/11/6.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "Test1ViewController.h"

#define WIDTH 50
@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawLayer];
}

#pragma mark - 绘制图层
- (void)drawLayer
{
    CGSize size=[UIScreen mainScreen].bounds.size;
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor colorWithRed:0 green:146/255.0 blue:1 alpha:1].CGColor;
    layer.position = CGPointMake(size.width/2., size.height/2.);
    layer.bounds = CGRectMake(0, 0, WIDTH, WIDTH);
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowOpacity = 0.9;
    layer.cornerRadius = WIDTH/2;
    [self.view.layer addSublayer:layer];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CALayer *layer = [self.view.layer.sublayers lastObject];
    CGFloat width = layer.frame.size.width;
    if (width == WIDTH)
    {
        width = 4*WIDTH;
    }else
    {
        width = WIDTH;
    }
    layer.bounds = CGRectMake(0, 0, width, width);
    layer.position = [touch locationInView:self.view];
    layer.cornerRadius = width/2;
    
    //    [layer needsDisplay];
}


@end
