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
#import "NeedDisplay.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) NSArray *arrayFontSize;
@property (strong, nonatomic) NeedDisplay *needDisplayView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self needDisplay];
    [self addPickView];

}
- (void)addPickView
{
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 300)];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [self.view addSubview:self.pickView];
}

- (void)needDisplay
{
    self.arrayFontSize = @[@15,@18,@20,@22,@25,@28,@30,@32,@35,@40];
    NeedDisplay *view=[[NeedDisplay alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    view.backgroundColor=[UIColor whiteColor];
    view.color = [UIColor redColor];
    view.title = @"Hello World";
    view.fontSize = [self.arrayFontSize[0] intValue];
    [self.view addSubview:view];
    self.needDisplayView = view;
    
//    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
//    self.label.text = @"Hello World";
//    self.label.textAlignment = NSTextAlignmentCenter;
//    self.label.textColor = [UIColor redColor];
//    [self.view addSubview:self.label];
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
#pragma mark - UIPickerView related
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayFontSize.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@号字体",self.arrayFontSize[row]];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.needDisplayView.fontSize = [self.arrayFontSize[row] intValue];

    [self.needDisplayView setNeedsDisplay];
//    self.label.font = [UIFont fontWithName:@"Marker Felt" size:[self.arrayFontSize[row] intValue]];
}
@end
