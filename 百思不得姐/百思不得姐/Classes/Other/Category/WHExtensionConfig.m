//
//  WHExtensionConfig.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/8/7.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHExtensionConfig.h"
#import "WHComment.h"
#import "WHTopic.h"

@implementation WHExtensionConfig
// 用到才调用
+ (void)initialize
{
    
}
// 加载内存中立即调用
+ (void)load
{
    [WHTopic mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"top_cmt":[WHComment class]};
    }];
    
    [WHTopic mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"top_cmt":@"top_cmt[0]",
                 @"small_image":@"image0",
                 @"large_image":@"image1",
                 @"middle_image":@"image2",
                 };
    }];
    
//    [WHTopic mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"ID":@"id"};
//    }];
//    
//    [WHComent mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"ID":@"id"};
//    }];
}
//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{@"top_cmt":@"WHComent"};
//}
//+ (id)mj_replacedKeyFromPropertyName
//{
//    return @{@"ID":@"id"};
//}
@end
