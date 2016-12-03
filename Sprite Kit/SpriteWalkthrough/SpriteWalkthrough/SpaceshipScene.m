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
    
    ///create rocks
    SKAction *makeRocks = [SKAction sequence:@[[SKAction performSelector:@selector(addRock) onTarget:self],
                                               [SKAction waitForDuration:0.1 withRange:0.15]
                                               ]];
    [self runAction:[SKAction repeatActionForever:makeRocks]];
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
    [hull runAction:[SKAction repeatActionForever:hover]];
    
    SKSpriteNode *light1 = [self newlight];
    light1.position = CGPointMake(-28, 6);
    [hull addChild:light1];
    
    SKSpriteNode *light2 = [self newlight];
    light2.position = CGPointMake(28, 6);
    [hull addChild:light2];
    
    ///添加物理模拟
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    
    return hull;
}
///两个内联函数是为了计算下落陨石的初始x坐标
static inline CGFloat skRandf()
{
    return rand()/(CGFloat)RAND_MAX;
}
static inline CGFloat skRand(CGFloat low,CGFloat hight)
{
    return skRandf()*(hight-low)+low;
}
- (SKSpriteNode *)addRock
{
    SKSpriteNode *rock = [[SKSpriteNode alloc]initWithColor:[SKColor brownColor] size:CGSizeMake(8, 8)];
    rock.name = @"rock";
    rock.position = CGPointMake(skRand(0, self.frame.size.width), self.frame.size.height);
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
    return rock;
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
- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.y<0)
        {
            [node removeFromParent];
        }
    }];
}
@end
