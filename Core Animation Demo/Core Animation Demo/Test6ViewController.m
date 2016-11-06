//
//  Test6ViewController.m
//  Core Animation Demo
//
//  Created by 肖伟华 on 2016/11/6.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "Test6ViewController.h"
#define IMAGE_COUNT 5

@interface Test6ViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) int currentIndex;
@end

@implementation Test6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView=[[UIImageView alloc]init];
    self.imageView.frame=[UIScreen mainScreen].bounds;
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.imageView.image=[UIImage imageNamed:@"00.jpg"];//默认图片
    [self.view addSubview:self.imageView];
    //添加手势
    UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];

}

#pragma mark - 向左滑动浏览下一张图片
-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transitionAnimation:YES];
}

#pragma mark - 向右滑动浏览上一张图片
-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transitionAnimation:NO];
}
#pragma mark - 转场动画
-(void)transitionAnimation:(BOOL)isNext
{
    //1.创建转场动画对象
    CATransition *transition=[[CATransition alloc]init];
    
    //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
//    transition.type = @"rippleEffect";
    
    //设置子类型
    if (isNext)
    {
        transition.type = @"pageCurl";
        transition.subtype = kCATransitionFromRight;
    }else{
        transition.type = @"pageUnCurl";
        transition.subtype = kCATransitionFromLeft;
    }
    //设置动画时常
    transition.duration = 1.0f;
    
    //3.设置转场后的新视图添加转场动画
    self.imageView.image = [self getImage:isNext];
    [self.imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
}
#pragma mark 取得当前图片
-(UIImage *)getImage:(BOOL)isNext
{
    if (isNext)
    {
        self.currentIndex = (self.currentIndex+1)%IMAGE_COUNT;
    }else{
        self.currentIndex = (self.currentIndex-1+IMAGE_COUNT)%IMAGE_COUNT;
    }
    NSString *imageName=[NSString stringWithFormat:@"0%i.jpg",self.currentIndex];
    return [UIImage imageNamed:imageName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
