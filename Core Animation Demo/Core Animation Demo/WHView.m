//
//  WHView.m
//  Core Animation Demo
//
//  Created by 肖伟华 on 2016/11/6.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHView.h"
#import "WHLayer.h"

@implementation WHView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        WHLayer *layer = [WHLayer layer];
        layer.bounds = CGRectMake(0, 0, 185, 185);
        layer.position = CGPointMake(frame.size.width/2.,frame.size.height/2.);
        layer.backgroundColor = [UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
        [self.layer addSublayer:layer];
        self.layer.delegate = self;
        // 视图刷新
        [layer setNeedsDisplay];
    }
    return self;
}

@end
