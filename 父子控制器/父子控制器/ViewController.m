//
//  ViewController.m
//  父子控制器
//
//  Created by 肖伟华 on 16/6/7.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "ViewController.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "Test3ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIButton *btn1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self addAllChildVC];
    
    [self setBtnTitle];
    
    [self one:self.btn1];
}
- (void)setBtnTitle
{
    for (int i = 0 ; i < self.viewTitle.subviews.count; i++) {
        UIButton *btn = self.viewTitle.subviews[i];
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
    }
}
- (void)addAllChildVC
{
    Test1ViewController *vcTest1 = [[Test1ViewController alloc]init];
    vcTest1.title = @"Test1";
    [self addChildViewController:vcTest1];
    
    Test2ViewController *vcTest2 = [[Test2ViewController alloc]init];
    vcTest2.title = @"Test2";
    [self addChildViewController:vcTest2];

    Test3ViewController *vcTest3 = [[Test3ViewController alloc]init];
    vcTest3.title = @"Test3";
    [self addChildViewController:vcTest3];

}

- (IBAction)one:(UIButton *)sender {
    for (UIView *views in self.viewContent.subviews) {
        [views removeFromSuperview];
    }
    
    UIViewController *vc = self.childViewControllers[sender.tag-1];
    vc.view.frame = self.viewContent.bounds;
    [self.viewContent addSubview:vc.view];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
