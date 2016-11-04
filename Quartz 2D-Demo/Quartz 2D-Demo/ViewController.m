//
//  ViewController.m
//  Quartz 2D-Demo
//
//  Created by STMBP on 2016/11/4.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "ViewController.h"
#import "WHView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    Test *view=[[Test alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    view.backgroundColor=[UIColor orangeColor];
//    [self.view addSubview:view];
    
    [self baseGrapicDraw];
}
- (void)baseGrapicDraw
{
    WHView *view=[[WHView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
