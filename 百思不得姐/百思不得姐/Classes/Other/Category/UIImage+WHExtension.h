//
//  UIImage+WHExtension.h
//  百思不得姐
//
//  Created by STMBP on 16/8/15.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WHExtension)
/**
 * 返回一张圆形图片
 */
- (instancetype)circleImage;

/**
 * 返回一张圆形图片
 */
+ (instancetype)circleImageNamed:(NSString *)name;
@end
