//
//  UIView+WHExtension.h
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WHExtension)
@property (assign, nonatomic) CGFloat wh_width;
@property (assign, nonatomic) CGFloat wh_height;

@property (assign, nonatomic) CGFloat wh_x;
@property (assign, nonatomic) CGFloat wh_y;

@property (assign, nonatomic) CGFloat wh_centerX;
@property (assign, nonatomic) CGFloat wh_centerY;

@property (assign, nonatomic) CGFloat wh_right;
@property (assign, nonatomic) CGFloat wh_bottom;

@property (assign, nonatomic) CGSize wh_size;

+ (instancetype)wh_viewFromXib;
@end
