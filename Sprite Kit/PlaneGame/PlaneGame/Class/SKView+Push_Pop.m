//
//  SKView+Push_Pop.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/11.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "SKView+Push_Pop.h"

@interface SKView ()
@end
static NSMutableArray *sceneArray = nil;

@implementation SKView (Push_Pop)

- (void)pushScene:(SKScene *)scene
{
    [self pushScene:scene transition:nil];
}
- (void)pushScene:(SKScene *)scene transition:(SKTransition *)transition
{
    if (scene == nil || ![scene isKindOfClass:[SKScene class]])
    {
        return;
    }

    if (!sceneArray)
    {
        sceneArray = [NSMutableArray array];
    }
    [sceneArray addObject:scene];
    [self presentScene:scene transition:transition];
}

- (void)popScene
{
    [self popSceneTransition:nil];
}

- (void)popSceneTransition:(SKTransition *)transition
{
    if (sceneArray.count > 1)
    {
        [sceneArray removeObjectAtIndex:sceneArray.count-1];
        [self presentScene:[sceneArray lastObject] transition:transition];
    }
}

- (NSArray *)sceneArray
{
    return sceneArray;
}

@end
