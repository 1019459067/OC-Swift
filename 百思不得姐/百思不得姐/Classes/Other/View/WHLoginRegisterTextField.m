//
//  WHLoginRegisterTextField.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/17.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHLoginRegisterTextField.h"

@implementation WHLoginRegisterTextField

- (void)awakeFromNib
{
    self.tintColor = [UIColor whiteColor];
    
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSForegroundColorAttributeName] = [UIColor redColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.placeholder attributes:attributes];
}

#pragma mark 重写
//- (CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(60, 0, 20, 40);
//}
- (void)drawPlaceholderInRect:(CGRect)rect
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attributes[NSFontAttributeName] = self.font;

//    CGRect rectPlaceholder ;
//    rectPlaceholder.size.width =  rect.size.width;
//    rectPlaceholder.size.width =  self.font.lineHeight;
//    rectPlaceholder.origin.x = 0;
//    rectPlaceholder.origin.y = (rect.size.height - rectPlaceholder.size.width)/2.0;
//    [self.placeholder drawInRect:CGRectMake(0, 10, rect.size.width, rect.size.height) withAttributes:attributes];
    
    [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height - self.font.lineHeight)/2.0) withAttributes:attributes];
}
@end
