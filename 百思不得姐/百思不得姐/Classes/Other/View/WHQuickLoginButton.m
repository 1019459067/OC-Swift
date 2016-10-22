//
//  WHQuickLoginButton.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/16.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHQuickLoginButton.h"

@implementation WHQuickLoginButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.wh_y = 0;
    self.imageView.wh_centerX = self.wh_width * 0.5;
    
    self.titleLabel.wh_centerX = self.wh_width * 0.5;
    self.titleLabel.wh_y = self.imageView.wh_bottom;
    self.titleLabel.wh_height = self.wh_height-self.imageView.wh_height;
    self.titleLabel.wh_width = self.wh_width;
}

@end
