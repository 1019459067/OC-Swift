//
//  PGButton.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/10.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "PGButton.h"

typedef void (^Block)();
@interface PGButton ()
@property (strong, nonatomic) Block block;
@end
@implementation PGButton

- (instancetype)initWithCenter:(CGPoint)center bound:(CGRect)bounds title:(NSString *)title
{
    if (self = [super init])
    {
        self.center = center;
        self.bounds = bounds;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [[UIColor grayColor] CGColor];
        self.titleLabel.font = [UIFont fontWithName:Chalkduster size:21];
        self.layer.cornerRadius = self.frame.size.height/2.;

        [self addTarget:self action:@selector(onAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)didClicked:(void(^)())completion
{
    self.block = completion;
}
- (void)onAction
{
    self.block();
}
@end
