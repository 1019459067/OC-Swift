//
//  NSObject+Calculate.h
//  Masonry分析
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculateMgr.h"

@interface NSObject (Calculate)

+ (int)wh_makeCalculate:(void(^)(CalculateMgr *mgr))block;

@end
