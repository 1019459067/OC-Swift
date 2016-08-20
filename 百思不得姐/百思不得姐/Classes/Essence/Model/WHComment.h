//
//  WHComent.h
//  百思不得姐
//
//  Created by 肖伟华 on 16/8/2.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,WHTopicType) {
    /** 全部 */
    WHTopicTypeAll = 1,
    /** 图片 */
    WHTopicTypePicture = 10,
    /** 段子(文字) */
    WHTopicTypeWord = 29,
    /** 声音 */
    WHTopicTypeVoice = 31,
    /** 视频 */
    WHTopicTypeVideo = 41
};

@class WHUser;
@interface WHComment : NSObject

/** id */
//@property (nonatomic, copy) NSString *ID;

/** 文字内容 */
@property (nonatomic, copy) NSString *content;

/** 点赞数 */
@property (nonatomic, assign) NSInteger like_count;

/** 语音文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;

/** 语音文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;

/** 用户 */
@property (nonatomic, strong) WHUser *user;

@end
