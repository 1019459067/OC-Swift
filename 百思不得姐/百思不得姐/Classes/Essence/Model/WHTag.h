//
//  WHTag.h
//  百思不得姐
//
//  Created by XWH on 16/15/08.
//  Copyright (c) 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHTag : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
@end
