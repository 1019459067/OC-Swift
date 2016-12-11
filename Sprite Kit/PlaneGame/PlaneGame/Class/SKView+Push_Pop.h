//
//  SKView+Push_Pop.h
//  PlaneGame
//
//  Created by STMBP on 2016/12/11.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKView (Push_Pop)

- (NSArray *)sceneArray;

- (void)pushScene:(SKScene *)scene;
- (void)pushScene:(SKScene *)scene transition:(SKTransition *)transition;

- (void)popScene;
- (void)popSceneTransition:(SKTransition *)transition;

@end
