//
//  UIImageView+WHExtension.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/8/15.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "UIImageView+WHExtension.h"

@implementation UIImageView (WHExtension)

- (void)setHeader:(NSString *)url
{
    [self setCircleHeader:url];
}

- (void)setRectHeader:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

- (void)setCircleHeader:(NSString *)url
{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return ;
        self.image = [image circleImage];
    }];
}
@end
