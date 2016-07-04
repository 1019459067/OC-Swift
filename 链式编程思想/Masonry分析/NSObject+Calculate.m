//
//  NSObject+Calculate.m
//  Masonry分析
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "NSObject+Calculate.h"
#import "CalculateMgr.h"

@implementation NSObject (Calculate)
+ (int)wh_makeCalculate:(void (^)(CalculateMgr *))block
{
    CalculateMgr *mgr = [[CalculateMgr alloc]init];
    block(mgr);
    
    return mgr.iRet;
}
@end
