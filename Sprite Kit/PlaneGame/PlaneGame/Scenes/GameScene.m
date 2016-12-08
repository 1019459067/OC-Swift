//
//  GameScene.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/8.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
@property (assign, nonatomic) BOOL contentCreated;
@end
@implementation GameScene

- (void)didChangeSize:(CGSize)oldSize
{
    if (!self.contentCreated)
    {
        self.contentCreated = YES;
        [self createScenesContents];
    }
}
- (void)createScenesContents
{
    self.backgroundColor = [SKColor darkGrayColor];
}
@end
