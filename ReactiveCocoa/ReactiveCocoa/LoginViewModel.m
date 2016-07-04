//
//  LoginViewModel.m
//  ReactiveCocoa
//
//  Created by 肖伟华 on 16/7/4.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    //处理登陆的点击信号
    _signalBtnLogin = [RACSignal combineLatest:@[RACObserve(self, strName),RACObserve(self, strPWD)] reduce:^id(NSString *strName,NSString *strPWD){
        return @(strName.length && strPWD.length);
    }];
    
    //处理登陆点击命令
    _commandLogin = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"send login request");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"data to login request"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    //处理登陆请求的结果
    //获取命令中的信号源
    [_commandLogin.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"x:%@",x);
    }];
    //处理登陆的执行过程
    [[_commandLogin.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            NSLog(@"yes");
        }else{
            NSLog(@"no");
        }
    }];

}
@end
