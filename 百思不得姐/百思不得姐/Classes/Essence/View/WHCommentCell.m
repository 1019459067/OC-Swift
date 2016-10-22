//
//  WHCommentCell.m
//  百思不得姐
//
//  Created by XWH on 16/8/20.
//  Copyright (c) 2015年 XWH. All rights reserved.
//

#import "WHCommentCell.h"
#import "WHComment.h"
#import "WHUser.h"
#import "UIImageView+WHExtension.h"

@interface WHCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@end

@implementation WHCommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setComment:(WHComment *)comment
{
    _comment = comment;
    
    if (comment.voiceuri.length)
    {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    }
    else
    {
        self.voiceButton.hidden = YES;
    }
    
    [self.profileImageView setHeader:comment.user.profile_image];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    if ([comment.user.sex isEqualToString:WHUserSexMale]) {
        self.sexView.image = [UIImage imageNamed:@"Profile_manIcon"];
    } else {
        self.sexView.image = [UIImage imageNamed:@"Profile_womanIcon"];
    }
}
- (IBAction)playVoice:(UIButton *)sender
{
    WHLogFunc
}

@end
