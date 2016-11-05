//
//  NeedDisplay.m
//  Quartz 2D-Demo
//
//  Created by 肖伟华 on 2016/11/5.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "NeedDisplay.h"

@implementation NeedDisplay

- (void)drawRect:(CGRect)rect
{
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = [UIFont fontWithName:@"Marker Felt" size:_fontSize];
    attri[NSForegroundColorAttributeName] = self.color;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentCenter;
    attri[NSParagraphStyleAttributeName] = style;
//    CGRect rectTitle = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.title drawInRect:rect withAttributes:attri];
}

@end
