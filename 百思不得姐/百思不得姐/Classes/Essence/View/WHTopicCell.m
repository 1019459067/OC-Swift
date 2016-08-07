//
//  WHTopicCell.m
//  百思不得姐
//
//  Created by STMBP on 16/7/26.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHTopicCell.h"
#import "WHTopic.h"
#import "UIImageView+WebCache.h"
#import "WHComent.h"
#import "WHUser.h"
#import "WHTopicVideoView.h"
#import "WHTopicVoiceView.h"
#import "WHTopicPictureView.h"

@interface WHTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 图片 */
@property (nonatomic, weak) WHTopicPictureView *pictureView;
/** 视频 */
@property (nonatomic, weak) WHTopicVideoView *videoView;
/** 声音 */
@property (nonatomic, weak) WHTopicVoiceView *voiceView;

/** 最热评论-整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
/** 最热评论-文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

@end
@implementation WHTopicCell

- (WHTopicPictureView *)pictureView
{
    if (!_pictureView) {
        WHTopicPictureView *pictureView = [WHTopicPictureView wh_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (WHTopicVideoView *)videoView
{
    if (!_videoView) {
        WHTopicVideoView *videoView = [WHTopicVideoView wh_viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (WHTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        WHTopicVoiceView *voiceView = [WHTopicVoiceView wh_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}


- (void)setTopic:(WHTopic *)topic
{
    _topic = topic;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = topic.name;
    
    self.createdAtLabel.text = topic.created_at;
    self.text_label.text = topic.text;
    

    // 设置底部工具条的数字
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    
//    WHLog(@"ID = %@",topic.ID);
//    if ([topic.ID isEqualToString:@"19721017"])
//    {
//        WHLog(@"name = %@",topic.name);
//    }
    //最热评论
    if (topic.top_cmt)
    {
        NSString *username = topic.top_cmt.user.username;
        NSString *content = topic.top_cmt.content;
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@",username,content];

        self.topCmtView.hidden = NO;
    }else
    {
        self.topCmtView.hidden = YES;
    }
    
    //处理中间内容
    // 根据帖子的类型决定中间的内容
    if (topic.type == WHTopicTypePicture) { // 图片
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
        self.pictureView.frame = topic.contentF;
        self.pictureView.topic = topic;
//        [self.contentView addSubview:self.pictureView];
    } else if (topic.type == WHTopicTypeVoice) { // 声音
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.frame = topic.contentF;
//        self.voiceView.topic = topic;
//        [self.contentView addSubview:self.voiceView];
    } else if (topic.type == WHTopicTypeVideo) { // 视频
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.frame = topic.contentF;
        WHLog(@"%@",NSStringFromCGRect(topic.contentF));
//        self.videoView.topic = topic;
//        [self.contentView addSubview:self.videoView];
    } else if (topic.type == WHTopicTypeWord) { // 文字
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }

}
- (IBAction)onActionMore:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}
/**
 * 设置工具条按钮的文字
 */
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= WHMargin;
//    frame.origin.x = WHMargin;
//    frame.size.width -= WHMargin*2;
    [super setFrame:frame];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.wh_height -=10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
