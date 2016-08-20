//
//  WHCommentCell.h
//  百思不得姐
//
//  Created by XWH on 16/8/20.
//  Copyright (c) 2015年 XWH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHComment;

@interface WHCommentCell : UITableViewCell
/** 评论模型数据 */
@property (nonatomic, strong) WHComment *comment;
@end
