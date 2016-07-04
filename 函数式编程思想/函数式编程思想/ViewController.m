//
//  ViewController.m
//  函数式编程思想
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "ViewController.h"
#import "CalculateMgr.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CalculateMgr *mgr = [[CalculateMgr alloc]init];
    
   int result = [mgr calculate:^(int result){
        result += 5;
        result *= 5;
        return result;
    }].iRet;
    NSLog(@"iRet : %d",result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
