//
//  CalculateMgr.m
//  Masonry分析
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "CalculateMgr.h"

@implementation CalculateMgr

- (CalculateMgr *(^)(int))add
{
    return ^(int value){
        self.iRet += value;
        return self;
    };
}
@end
