//
//  ViewController.m
//  响应式编程思想
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
@property (strong, nonatomic) Person *p;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Person *p = [[Person alloc]init];
    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];

    self.p = p;
    
    /*
     KVO实现
     本质：监听对象是否调用set方法
     
     */
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"p: %@",self.p.name);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static int i = 0;
    self.p.name = [NSString stringWithFormat:@"name:%d",i++];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
