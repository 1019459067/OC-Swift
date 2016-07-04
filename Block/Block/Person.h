//
//  Person.h
//  Block
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BlockName)();

@interface Person : NSObject

@property (strong, nonatomic) void (^operation)();

//参数类型
- (void)eat:(void(^)())block;
//- (void)eat:(BlockName)block;

- (void (^)(int meter))run;
@end
