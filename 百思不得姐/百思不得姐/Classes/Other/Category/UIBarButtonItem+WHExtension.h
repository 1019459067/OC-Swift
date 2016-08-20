//
//  UIBarButtonItem+WHExtension.h
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/12.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WHExtension)
+ (instancetype)itemWithImage:(NSString *)strImg hightImage:(NSString *)strHightImg action:(SEL)action addTarget:(id)target;
@end
