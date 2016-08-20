//
//  WHCommentViewController.h
//  百思不得姐
//
//  Created by XWH on 16/8/20.
//  Copyright (c) 2015年 XWH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHTopic;

@interface WHCommentViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) WHTopic *topic;
@end
