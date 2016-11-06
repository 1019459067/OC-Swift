//
//  Test4ViewController.m
//  Core Animation Demo
//
//  Created by 肖伟华 on 2016/11/6.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "Test4ViewController.h"

@interface Test4ViewController ()

@end

@implementation Test4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self testAnimation];
}
- (void)testAnimation
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
    imageView.center = CGPointMake(self.view.frame.size.width/2., self.view.frame.size.height/2.);
    imageView.image = [UIImage imageNamed:@"08.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    //两秒后开始一个持续一分钟的动画
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        imageView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
