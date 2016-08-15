//
//  WHTagCell.m
//  百思不得姐
//
//  Created by XWH on 16/15/08.
//  Copyright (c) 2016年 XWH. All rights reserved.
//

#import "WHTagCell.h"
#import "WHTag.h"
#import "UIImageView+WebCache.h"

@interface WHTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@end

@implementation WHTagCell

/**
 * 重写这个方法的目的：拦截cell的frame设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (void)setTagModel:(WHTag *)tagModel
{
    _tagModel = tagModel;
    
    // 设置头像
//    [self.imageListView setHeader:tagModel.image_list];
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self.imageListView sd_setImageWithURL:[NSURL URLWithString:tagModel.image_list] placeholderImage:placeholder];
    self.themeNameLabel.text = tagModel.theme_name;
    
    // 订阅数
    if (tagModel.sub_number >= 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅", tagModel.sub_number / 10000.0];
    } else {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%zd人订阅", tagModel.sub_number];
    }
}

@end
