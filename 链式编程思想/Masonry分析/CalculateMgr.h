//
//  CalculateMgr.h
//  Masonry分析
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateMgr : NSObject

@property (assign, nonatomic) int iRet;

- (CalculateMgr *(^)(int num))add;

@end
