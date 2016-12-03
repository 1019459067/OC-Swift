//
//  SpaceshipScene.m
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/3.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "SpaceshipScene.h"

@interface SpaceshipScene()
@property BOOL contentCreated;
@end

@implementation SpaceshipScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.contentCreated = YES;
        [self createSceneContents];
    }
}
- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    SKSpriteNode *spaceShip = [self newSpaceShip];
    spaceShip.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:spaceShip];
    
}
- (SKSpriteNode *)newSpaceShip
{
    SKSpriteNode *hull = [[SKSpriteNode alloc]initWithColor:[SKColor grayColor] size:CGSizeMake(33, 24)];
    SKAction *hover = [SKAction sequence:@[[SKAction waitForDuration:1],
                                           [SKAction moveByX:100 y:50 duration:1],
                                           
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100 y:-50 duration:1],
                                           
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100 y:50 duration:1],

                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:-50 duration:1],
                                           ]];
    [hull runAction:[SKAction repeatActionForever:hover] completion:^{
        
    }];
    
    SKSpriteNode *light1 = [self newlight];
    light1.position = CGPointMake(-28, 6);
    [hull addChild:light1];
    
    SKSpriteNode *light2 = [self newlight];
    light2.position = CGPointMake(28, 6);
    [hull addChild:light2];
    return hull;
}

- (SKSpriteNode *)newlight
{
    SKSpriteNode *light = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(8, 8)];
    SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]
                                           ]];
    [light runAction:[SKAction repeatActionForever:blink]];
    return light;
}
@end
