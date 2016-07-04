//
//  CalculateMgr.h
//  函数式编程思想
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateMgr : NSObject

@property (assign, nonatomic) int iRet;

- (instancetype)calculate:(int(^)(int result))calculateBlock;

@end
