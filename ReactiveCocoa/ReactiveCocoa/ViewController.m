//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "ViewController.h"
#import "GlobeHeader.h"
#import "LoginViewModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *labelName;
@property (weak, nonatomic) IBOutlet UITextField *labelPWD;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

@property (strong, nonatomic) id<RACSubscriber> subscriber;
@property (strong, nonatomic) LoginViewModel *loginVM;
@end

@implementation ViewController

- (LoginViewModel *)loginVM
{
    if (!_loginVM) {
        _loginVM = [[LoginViewModel alloc]init];
    }
    return _loginVM;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    /*
        MVVM
        VM:视图模型，处理界面上的所有业务逻辑，最好不要包含试图
     
     */
    [self blindViewModel];
    
    [self loginEvent];
}
- (void)blindViewModel
{
    //1.绑定
    RAC(self.loginVM,strName) = self.labelName.rac_textSignal;
    RAC(self.loginVM,strPWD) = self.labelPWD.rac_textSignal;
}
- (void)loginEvent
{
    //设置按钮能否点击
    RAC(self.buttonLogin,enabled) = self.loginVM.signalBtnLogin;
    
    //登陆命令
    [[self.buttonLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        NSLog(@"clicked login button");
        [self.loginVM.commandLogin execute:nil];
    }];
}
//先发送，后订阅
- (void)RACReplaySubject
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [subject sendNext:@"1"];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"x:%@",x);
    }];

}
//先订阅，后发送
- (void)RACSubject
{
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"x:%@",x);
    }];
    
    [subject sendNext:@"1"];

}
//先订阅，后发送
- (void)RACSignal
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.subscriber = subscriber;
        [subscriber sendNext:@1];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispos able");
        }];
    }];
    
    RACDisposable  *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"x:%@",x);
    }];
    
    [disposable dispose];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
