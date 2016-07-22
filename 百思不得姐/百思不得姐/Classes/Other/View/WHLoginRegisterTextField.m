//
//  WHLoginRegisterTextField.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/17.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHLoginRegisterTextField.h"
#import <objc/runtime.h>

static  NSString * const WHPlaceHolderString = @"placeholderLabel.textColor";
@implementation WHLoginRegisterTextField

- (void)awakeFromNib
{
    self.tintColor = [UIColor whiteColor];
    
    //运行时
//    unsigned int icount;
//    Ivar *ivarList = class_copyIvarList([UITextField class], &icount);
//
//    for (int i = 0 ; i < icount; i++)
//    {
//        Ivar ivar = ivarList[i];
//        WHLog(@"ivarName : %s",ivar_getName(ivar));
//    }
//    free(ivarList);
    //设置默认的占位 颜色
    [self setValue:[UIColor grayColor] forKeyPath:WHPlaceHolderString];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editingDidBegin:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editingDidEnd:) name:UITextFieldTextDidEndEditingNotification object:self];
    //代理
//    [self addTarget:self action:@selector(editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
//    [self addTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];

//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSForegroundColorAttributeName] = [UIColor redColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.placeholder attributes:attributes];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)editingDidBegin:(NSNotification *)noti
{
    [self setValue:[UIColor whiteColor] forKeyPath:WHPlaceHolderString];
}
- (void)editingDidEnd:(NSNotification *)noti
{
    [self setValue:[UIColor darkGrayColor] forKeyPath:WHPlaceHolderString];
}

#pragma mark 重写
//- (CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(60, 0, 20, 40);
//}
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    attributes[NSFontAttributeName] = self.font;
//
////    CGRect rectPlaceholder ;
////    rectPlaceholder.size.width =  rect.size.width;
////    rectPlaceholder.size.width =  self.font.lineHeight;
////    rectPlaceholder.origin.x = 0;
////    rectPlaceholder.origin.y = (rect.size.height - rectPlaceholder.size.width)/2.0;
////    [self.placeholder drawInRect:CGRectMake(0, 10, rect.size.width, rect.size.height) withAttributes:attributes];
//    
//    [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height - self.font.lineHeight)/2.0) withAttributes:attributes];
//}
@end
