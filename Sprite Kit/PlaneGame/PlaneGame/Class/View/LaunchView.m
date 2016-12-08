//
//  LaunchView.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/7.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "LaunchView.h"

#define RImageCount 4

@implementation LaunchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor blackColor];

        NSMutableArray *images = [NSMutableArray arrayWithCapacity:RImageCount];
        for (NSInteger i = 0; i < RImageCount; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"loading%ld.png", (long)i];
            UIImage *image = [UIImage imageNamed:imageName];

            [images addObject:image];
        }

        UIImageView *imageView = [[UIImageView alloc] initWithImage:images[0]];
        imageView.center = self.center;
        [self addSubview:imageView];

        imageView.animationImages = images;
        imageView.animationDuration = 1.0f;

        [imageView startAnimating];
    }
    return self;
}
@end
