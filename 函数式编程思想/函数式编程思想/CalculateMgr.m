//
//  CalculateMgr.m
//  函数式编程思想
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "CalculateMgr.h"

@implementation CalculateMgr

- (instancetype)calculate:(int(^)(int result))calculateBlock
{
    self.iRet = calculateBlock(self.iRet);
    return self;
}
@end
