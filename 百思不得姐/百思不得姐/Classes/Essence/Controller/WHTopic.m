//
//  WHTopic.m
//  百思不得姐
//
//  Created by STMBP on 16/7/25.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHTopic.h"
#import "NSDate+WHExtension.h"
#import "WHComment.h"
#import "WHUser.h"

static const NSDateFormatter *fmt_;

@implementation WHTopic

//#pragma mark - MJExtension
//
//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{@"top_cmt":@"WHComent"};
//}
//+ (id)mj_replacedKeyFromPropertyName
//{
//    return @{@"ID":@"id"};
//}
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


- (CGFloat)cellHeight
{
    if (_cellHeight) return _cellHeight;
    //头像
    _cellHeight =  55;
    
     //文字
    CGFloat textMaxW = WH_ScreenW-2*WHMargin;
    CGSize textMaxSize = CGSizeMake(textMaxW, MAXFLOAT);
    CGSize textSize = [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _cellHeight += textSize.height+WHMargin;

    // 中间内容的高度
    if (self.type != WHTopicTypeWord) {
        CGFloat contentW = textMaxW;
        // 图片的高度 * 内容的宽度 / 图片的宽度
        CGFloat contentH = self.height * contentW / self.width;
        if (contentH >= WH_ScreenH) { // 一旦图片的显示高度超过一个屏幕，就让图片高度为200
            contentH = 200;
            self.bigPicture = YES;
        }
        
        CGFloat contentX = WHMargin;
        CGFloat contentY = _cellHeight;
        self.contentF = CGRectMake(contentX, contentY, contentW, contentH);
        
        _cellHeight += contentH + WHMargin;
    }
    // 最热评论
    if (self.top_cmt)
    {
        _cellHeight += 20;// 标题
        NSString *topCmtContent = [NSString stringWithFormat:@"%@ : %@",self.top_cmt.user.username,self.top_cmt.content];
        CGSize topCmtContentSize = [topCmtContent boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        _cellHeight += topCmtContentSize.height+WHMargin;
    }
    //工具条
    _cellHeight += 35+WHMargin;
    
    return _cellHeight;
}
@end
