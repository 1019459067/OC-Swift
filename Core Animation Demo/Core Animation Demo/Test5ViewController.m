//
//  Test5ViewController.m
//  Core Animation Demo
//
//  Created by 肖伟华 on 2016/11/6.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "Test5ViewController.h"

@interface Test5ViewController ()<CAAnimationDelegate>
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
 
    [self translationAnimation];
}
#pragma mark - 关键帧动画/贝塞尔曲线
- (void)translationAnimation
{
    //1.创建关键帧动画并设置动画属性
    CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //2.设置关键帧,这里有四个关键帧
    //绘制贝塞尔曲线
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.layer.position.x, self.layer.position.y);//移动到起始点
    CGPathAddCurveToPoint(path, NULL, 160, 280, -30, 300, 55, 400);//绘制二次贝塞尔曲线
    
    keyframeAnimation.path=path;//设置path属性
    CGPathRelease(path);//释放路径对象
    //设置其他属性
    keyframeAnimation.duration=8.0;
    keyframeAnimation.beginTime=CACurrentMediaTime()+5;//设置延迟2秒执行
    
    
    //3.添加动画到图层，添加动画后就会执行动画
    [self.layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
}
#pragma mark - 移动动画
- (void)moveTransformAnimationWithPoint:(CGPoint)point
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    baseAnimation.toValue = [NSValue valueWithCGPoint:point];
    
    // time
    baseAnimation.duration = 6;

//    baseAnimation.autoreverses = YES;
//    baseAnimation.removedOnCompletion = NO;
//    baseAnimation.repeatCount = 1;
    
    baseAnimation.delegate = self;
    [baseAnimation setValue:baseAnimation.toValue forKey:@"k_ToValue"];
    
    [self.layer addAnimation:baseAnimation forKey:@"k_BaseAnimation_Transform"];
}
#pragma mark - 旋转动画
- (void)rotationAnimation
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.duration = 5;
    basicAnimation.removedOnCompletion = YES;
    basicAnimation.toValue = [NSNumber numberWithFloat:M_PI*3];
//    basicAnimation.autoreverses = YES;
    
    [self.layer addAnimation:basicAnimation forKey:@"k_BaseAnimation_Rotation"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    [self moveTransformAnimationWithPoint:point];
//    [self rotationAnimation];
    
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.layer.position = [[anim valueForKey:@"k_ToValue"]CGPointValue];
    [CATransaction commit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
