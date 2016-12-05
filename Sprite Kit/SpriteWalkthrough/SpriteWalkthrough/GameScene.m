//
//  GameScene.m
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/5.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameScene.h"
#import "ButtonNode.h"
#import "HomeScene.h"

@interface GameScene ()
@property (assign, nonatomic) BOOL contentCreated;
@end
@implementation GameScene
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
        /// back button
    ButtonNode *back = [[ButtonNode alloc]init];
    back.text = @"返回";
    back.fontColor = [SKColor whiteColor];
    back.position = CGPointMake(40, self.size.height-50);
    [back didClickedMethod:^{
        [self backHome];
    }];
    [self addChild:back];

    [self newShip];

        /// add rocks
    SKAction *makeRocks = [SKAction sequence:@[[SKAction performSelector:@selector(addRocks) onTarget:self],
                                               [SKAction waitForDuration:0.1 withRange:0.01]]];
    [self runAction:[SKAction repeatActionForever:makeRocks]];
}
static inline CGFloat skRandf()
{
    return rand()/(CGFloat)RAND_MAX;
}
static inline CGFloat skRand(CGFloat start,CGFloat end)
{
    return skRandf()*(end-start)+start;
}
- (void)addRocks
{
    SKSpriteNode *rock = [[SKSpriteNode alloc]initWithColor:[SKColor brownColor] size:CGSizeMake(8, 8)];
    rock.name = @"rock";
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    rock.position = CGPointMake(skRand(0, self.size.height), self.size.height);
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    [self addChild:rock];
}
- (void)newShip
{
    SKSpriteNode *hull = [[SKSpriteNode alloc]initWithColor:[SKColor grayColor] size:CGSizeMake(30, 20)];
    hull.name = @"ship";
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    hull.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:hull];

        ///add light
    SKSpriteNode *l1 = [self newLightWithPosition:CGPointMake(-18, 8)];
    [hull addChild:l1];

    SKSpriteNode *l2 = [self newLightWithPosition:CGPointMake(18, 8)];
    [hull addChild:l2];

        /// add action
//    int margin = 75;
//    SKAction *leftDown = [SKAction moveByX:-margin y:-margin duration:0.25];
//    SKAction *wait1 = [SKAction waitForDuration:0.3];
//
//    SKAction *down = [SKAction moveByX:margin y:-margin duration:0.25];
//    SKAction *wait2 = [SKAction waitForDuration:0.3];
//
//    SKAction *rightDown = [SKAction moveByX:margin y:margin duration:0.25];
//    SKAction *wait3 = [SKAction waitForDuration:0.3];
//
//    SKAction *zero = [SKAction moveByX:-margin y:margin duration:0.25];
//    SKAction *wait4 = [SKAction waitForDuration:0.3];
//
//    SKAction *square = [SKAction sequence:@[leftDown,wait1,
//                                            down,wait2,
//                                            rightDown,wait3,
//                                            zero,wait4,]];
//    [hull runAction:[SKAction repeatActionForever:square]];

}
- (SKSpriteNode *)newLightWithPosition:(CGPoint)point
{
    SKSpriteNode *light = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(2, 2)];
    light.position = point;
    light.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:light.size];
    light.physicsBody.dynamic = NO;

        /// add action
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.38];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.38];

    [light runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeIn,fadeOut]]]];
    return light;
}
- (void)backHome
{
    HomeScene *scene = [[HomeScene alloc]initWithSize:self.size];
    SKTransition *tran = [SKTransition doorsCloseVerticalWithDuration:0.5];
    [self.view presentScene:scene transition:tran];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SKNode *node = [self childNodeWithName:@"ship"];

        ///
    CGPoint pointTouch = [[touches anyObject]locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(pointTouch));
    node.position = CGPointMake(pointTouch.x, self.size.height-pointTouch.y);
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
