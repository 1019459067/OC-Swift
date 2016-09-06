//
//  ViewController.m
//  Block's strong&weak
//
//  Created by STMBP on 16/8/22.
//  Copyright © 2016年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
@property (copy, nonatomic) int(^sumBlock)(int,int);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Person *p = [[Person alloc]init];
    p.name = @"ST";
    
    __weak typeof(Person*) weakP = p;
    p.block = ^{
        Person *pStrong = weakP;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"==========%@",pStrong.name);
        });
    };
     p.block();
}
- (void)test
{
    Person *p = [[Person alloc]init];
    p.name = @"ST";
    
    __weak typeof(Person*) weakP = p;
    p.block = ^{
//        NSLog(@"==========");
//        NSLog(@"==========%@",p.name);
        NSLog(@"==========%@",weakP.name);
    };
    p.block();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
