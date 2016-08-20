//
//  WHCommentHeaderView.m
//  百思不得姐
//
//  Created by XWH on 15/9/17.
//  Copyright (c) 2015年 XWH. All rights reserved.
//

#import "WHCommentHeaderView.h"

@interface WHCommentHeaderView()
/** 内部的label */
@property (nonatomic, weak) UILabel *label;
@end

@implementation WHCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = WHColorCommonBg;
        
        UILabel *label = [[UILabel alloc] init];
        label.wh_x = WHSmallMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textColor = WHGrayColor(120);
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    self.label.text = text;
}
@end
