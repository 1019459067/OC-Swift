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
#import "GameViewController.h"

/*
 http://blog.csdn.net/kobbbb/article/details/9093601
 */
@interface GameScene ()
@property (assign, nonatomic) BOOL contentCreated;
@property (weak, nonatomic) SKLabelNode *labelNumber;
@property (weak, nonatomic) SKSpriteNode *ship;
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
    self.ship = hull;

    // add gesture
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];

        ///add light
    SKSpriteNode *l1 = [self newLightWithPosition:CGPointMake(-18, 8)];
    [hull addChild:l1];

    SKSpriteNode *l2 = [self newLightWithPosition:CGPointMake(18, 8)];
    [hull addChild:l2];

        //add label
    SKLabelNode *labelNumber = [[SKLabelNode alloc]init];
    labelNumber.text = @"sensetime";
    labelNumber.fontColor = [SKColor yellowColor];
    labelNumber.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*1/8.);
    [self addChild:labelNumber];
    self.labelNumber = labelNumber;
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

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    translation = CGPointMake(translation.x, -translation.y);
    [self panForTranslation:translation];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}
- (void)panForTranslation:(CGPoint)pointTran
{
    self.ship.position = CGPointMake(self.ship.position.x+pointTran.x, self.ship.position.y+pointTran.y);
}
- (SKSpriteNode *)newLightWithPosition:(CGPoint)point
{
    SKSpriteNode *light = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(12, 2)];
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
    
    GameViewController *vc = (GameViewController *) self.view.window.rootViewController;
    [vc stopTime];
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
- (void)update:(NSTimeInterval)currentTime
{
    GameViewController *vc = (GameViewController *) self.view.window.rootViewController;
    self.labelNumber.text = [NSString stringWithFormat:@"时间：%d s",vc.iNumber];
}
@end
