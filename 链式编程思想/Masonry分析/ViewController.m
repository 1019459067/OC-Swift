//
//  ViewController.m
//  Masonry分析
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "NSObject+Calculate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //链式编程思想
    int iRet = [NSObject wh_makeCalculate:^(CalculateMgr *mgr) {
        mgr.add(5).add(6).add(7);
    }];
    
    NSLog(@"Iret: %d",iRet);
}
- (void)masonry
{
    UIView *viewRed = [[UIView alloc]init];
    viewRed.backgroundColor = [UIColor redColor];
    [self.view addSubview:viewRed];
    
    [viewRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@20);
        make.bottom.right.equalTo(@-20);
    }];
    
    /*
     执行流程
     1)创建约束制造者MASConstraintMaker，并绑定控件,生成了一个保存所有约束的数组
     2)执行mas_makeConstraints传入的block
     3)让约束制造者安装约束
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
