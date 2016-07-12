//
//  WHItemManager.h
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/12.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHItemManager : NSObject

+ (UIBarButtonItem *)itemWithImage:(NSString *)strImg hightImag:(NSString *)strHightImg action:(SEL)action addTarget:(id)target;

@end
