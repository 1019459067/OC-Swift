//
//  LoginViewModel.h
//  ReactiveCocoa
//
//  Created by 肖伟华 on 16/7/4.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobeHeader.h"

@interface LoginViewModel : NSObject

@property (copy, nonatomic) NSString *strName;
@property (copy, nonatomic) NSString *strPWD;


//处理登陆按钮是否点击
@property (strong, nonatomic,readonly) RACSignal *signalBtnLogin;

//登陆按钮的命令
@property (strong, nonatomic,readonly) RACCommand *commandLogin;
@end
