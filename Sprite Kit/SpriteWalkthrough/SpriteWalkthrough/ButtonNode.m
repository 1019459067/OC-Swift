//
//  ButtonNode.m
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/5.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "ButtonNode.h"

typedef void (^AnonBlock)();

@interface ButtonNode ()
@property (strong, nonatomic) AnonBlock block;
@end
@implementation ButtonNode
- (instancetype)init
{
    if (self = [super init])
    {
        self.userInteractionEnabled = YES;
        self.block = ^{};
        self.name = @"button";
        self.fontSize = 20;
        self.fontColor = [SKColor whiteColor];
    }
    return self;
}
- (void)runBlock
{
    self.block();
}
- (void)didClickedMethod:(void (^)())completion
{
    self.block = completion;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject]locationInNode:self];
    SKNode *touchNode = [self nodeAtPoint:location];
    if ([touchNode.name isEqualToString:@"button"])
    {
        [self runBlock];
    }
}
@end
