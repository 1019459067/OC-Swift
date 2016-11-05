//
//  ViewController.m
//  Quartz 2D-Demo
//
//  Created by STMBP on 2016/11/4.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "ViewController.h"
#import "WHView.h"
#import "WHColorView.h"
#import "WHImgView.h"

@interface ViewController ()<CALayerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self imgGrapicDraw];
}
#pragma mark - 绘制矩形
- (void)imgGrapicDraw
{
    WHImgView *view=[[WHImgView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
}
- (void)colorGrapicDraw
{
    WHColorView *view=[[WHColorView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
}
- (void)baseGrapicDraw
{
    WHView *view=[[WHView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
