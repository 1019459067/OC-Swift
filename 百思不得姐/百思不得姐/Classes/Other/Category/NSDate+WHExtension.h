//
//  NSDate+WHExtension.h
//  百思不得姐
//
//  Created by 肖伟华 on 16/8/2.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WHExtension)

- (NSDateComponents *)intervalToNow;

/** 是否今年 */
- (BOOL)isThisYear;

/** 是否今天 */
- (BOOL)isToday;

/** 是否昨天 */
- (BOOL)isYesterday;

@end
