//
//  Test5ViewController.m
//  Core Animation Demo
//
//  Created by 肖伟华 on 2016/11/6.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "Test5ViewController.h"

@interface Test5ViewController ()
@property (strong, nonatomic) CALayer *layer;
@end

@implementation Test5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // set background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    // add layer
    self.layer = [CALayer layer];
    self.layer.bounds = CGRectMake(0, 0, 10, 20);
    self.layer.position = CGPointMake(50, 150);
    self.layer.contents = (id)[UIImage imageNamed:@"leaf"].CGImage;
    [self.view.layer addSublayer:self.layer];
}
#pragma mark - 移动动画
- (void)moveTransformAnimationWithPoint:(CGPoint)point
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    baseAnimation.toValue = [NSValue valueWithCGPoint:point];
    
    // time
    baseAnimation.duration = 2;
    
    [self.layer addAnimation:baseAnimation forKey:@"k_BaseAnimation_Transform"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    [self moveTransformAnimationWithPoint:point];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
