//
//  WHTopicVoiceView.m
//  百思不得姐
//
//  Created by XWH on 16/08/09.
//  Copyright (c) 2016年 XWH. All rights reserved.
//

#import "WHTopicVoiceView.h"
#import "WHTopic.h"
#import "UIImageView+WebCache.h"
#import "WHSeeBigViewController.h"

@interface WHTopicVoiceView()
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation WHTopicVoiceView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBig)]];
}

- (void)seeBig
{
    WHSeeBigViewController *seeBig = [[WHSeeBigViewController alloc] init];
    seeBig.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBig animated:YES completion:nil];
}

- (void)setTopic:(WHTopic *)topic
{
    _topic = topic;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    // %02zd ：显示这个数字需要占据2位空间，不足的空间用0替补
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}
@end
