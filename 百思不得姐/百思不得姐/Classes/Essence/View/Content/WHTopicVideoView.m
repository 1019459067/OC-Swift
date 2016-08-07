//
//  WHTopicVideoView.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/17.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "WHTopicVideoView.h"
#import "WHTopic.h"
//#import <UIImageView+AFNetworking.h>
//#import <UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
@interface WHTopicVideoView()
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation WHTopicVideoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
}
- (void)setTopic:(WHTopic *)topic
{
//    [super setTopic:topic];
//    
////    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
//    [_imageView setImageWithURL:[NSURL URLWithString:topic.large_image]];
//    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
//    
//    NSInteger minute = topic.videotime / 60;
//    NSInteger second = topic.videotime % 60;
//    // %02zd ：显示这个数字需要占据2位空间，不足的空间用0替补
//    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}
@end
