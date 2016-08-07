//
//  WHTopic.m
//  百思不得姐
//
//  Created by STMBP on 16/7/25.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHTopic.h"
#import "NSDate+WHExtension.h"
#import "MJExtension.h"
#import "WHComent.h"

static const NSDateFormatter *fmt_;

@implementation WHTopic

//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{@"ID":@"id"};
//}
+ (id)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
+ (void)initialize
{
    fmt_ = [[NSDateFormatter alloc] init];
    fmt_.dateFormat = @"yyyy-MM-dd HH:mm:ss";

}

#pragma mark - getter

- (NSString *)created_at
{
    // 日期格式化类
    NSDate *createdAtDate = [fmt_ dateFromString:_created_at];

    // 比较【发帖时间】和【手机当前时间】的差值
    NSDateComponents *cmps = [createdAtDate intervalToNow];

    if (createdAtDate.isThisYear) {
        if (createdAtDate.isToday) { // 今天
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1分钟 =< 时间差距 <= 59分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else {
                return @"刚刚";
            }
        } else if (createdAtDate.isYesterday) { // 昨天
            fmt_.dateFormat = @"昨天 HH:mm:ss";
            return [fmt_ stringFromDate:createdAtDate];
        } else { // 今年的其他时间
            fmt_.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt_ stringFromDate:createdAtDate];
        }
    } else { // 非今年
        return _created_at;
    }
}
@end
