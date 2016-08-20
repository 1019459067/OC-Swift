 //
//  WHTopic.h
//  百思不得姐
//
//  Created by STMBP on 16/7/25.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHComment.h"

@interface WHTopic : NSObject
//@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *profile_image;
/** 文字 */
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *created_at;
@property (assign, nonatomic) NSInteger ding;
@property (assign, nonatomic) NSInteger cai;
@property (assign, nonatomic) NSInteger repost;
@property (assign, nonatomic) NSInteger comment;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;

/** 小图 */
@property (nonatomic, copy) NSString *small_image; // image0
/** 大图 */
@property (nonatomic, copy) NSString *large_image; // image1
/** 中图 */
@property (nonatomic, copy) NSString *middle_image; // image2
/** 是否为动态图 */
@property (nonatomic, assign) BOOL is_gif;

/** 视频的时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 播放数量 */
@property (nonatomic, assign) NSInteger playcount;

//@property (strong, nonatomic) NSArray<WHComent *> *top_cmt;
/** 最热评论 */
@property (strong, nonatomic) WHComment *top_cmt;

/** 类型 */
@property (nonatomic, assign) WHTopicType type;


/** 额外的属性 */
@property (assign, nonatomic) CGFloat cellHeight;
/** 中间内容的 frame */
@property (assign, nonatomic) CGRect contentF;
/** 判断大图 */
@property (assign,nonatomic,getter=isBigPicture) BOOL bigPicture;
@end
