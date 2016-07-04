//
//  ViewController.m
//  Block
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
    p.run(2);

}
- (void)block2
{
    Person *p = [[Person alloc]init];
    [p eat:^{
        NSLog(@"eat");
    }];
}

//保存到对象中
- (void)block1
{
    Person *p = [[Person alloc]init];
    void (^block)() = ^(){
        NSLog(@"===!!!!");
    };
    
    p.operation = ^(){
        NSLog(@"===");
    };
    p.operation = block;
    self.p = p;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.p.operation();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
