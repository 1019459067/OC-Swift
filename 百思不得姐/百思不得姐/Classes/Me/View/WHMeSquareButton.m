//
//  WHMeSquareButton.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/24.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHMeSquareButton.h"
#import "UIButton+WebCache.h"
#import "WHMeSquare.h"

@implementation WHMeSquareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.wh_y = self.wh_height * 0.1;
    self.imageView.wh_height = self.wh_height * 0.5;
    self.imageView.wh_width = self.imageView.wh_height;
    self.imageView.wh_centerX = self.wh_width * 0.5;
    
    self.titleLabel.wh_x = 0;
    self.titleLabel.wh_y = self.imageView.wh_bottom;
    self.titleLabel.wh_width = self.wh_width;
    self.titleLabel.wh_height = self.wh_height-self.imageView.wh_height;
}

- (void)setSquare:(WHMeSquare *)square
{
    [self setTitle:square.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"setup-head-default"]];
}
@end
