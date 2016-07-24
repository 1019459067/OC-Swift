//
//  WHTitleButton.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/24.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHTitleButton.h"

@implementation WHTitleButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
