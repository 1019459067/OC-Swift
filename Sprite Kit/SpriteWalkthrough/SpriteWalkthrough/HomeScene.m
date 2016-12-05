//
//  HelloScene.m
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/3.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "HomeScene.h"
#import "SpaceshipScene.h"
#import "ButtonNode.h"
#import "GameScene.h"

@interface HomeScene ()
@property BOOL contentCreated;
@end

@implementation HomeScene
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

    [self addChild:[self newHelloNode]];

    [self newLabelNode];
    [self newButtonNode];
}
- (void)newButtonNode
{
    ButtonNode *buttonNode = [[ButtonNode alloc]init];
    buttonNode.text = @"start game";
    buttonNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

    [buttonNode didClickedMethod:^{
        [self openSceneGame];
    }];
    [self addChild:buttonNode];
}
- (void)newLabelNode
{
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelNode.text = @"👻👻";
    labelNode.name = @"labelNode";
    labelNode.fontSize = 30;
    labelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+200);
    [self addChild:labelNode];
}

- (void)openSceneGame
{
    GameScene *game = [[GameScene alloc]initWithSize:self.size];
    SKTransition *tran = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:game transition:tran];
}
- (SKLabelNode *)newHelloNode
{
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelNode.text = @"Hello,World!";
    labelNode.fontSize = 42;
    labelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    labelNode.name = @"helloNode";
    return labelNode;
}
#pragma mark - responder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SKNode *labelNode = [self childNodeWithName:@"labelNode"];
    if (labelNode)
    {
        int margin = 75;
        labelNode.name = nil;
        SKAction *leftDown = [SKAction moveByX:-margin y:-margin duration:0.25];
        SKAction *wait1 = [SKAction waitForDuration:0.3];

        SKAction *down = [SKAction moveByX:margin y:-margin duration:0.25];
        SKAction *wait2 = [SKAction waitForDuration:0.3];

        SKAction *rightDown = [SKAction moveByX:margin y:margin duration:0.25];
        SKAction *wait3 = [SKAction waitForDuration:0.3];

        SKAction *zero = [SKAction moveByX:-margin y:margin duration:0.25];
        SKAction *wait4 = [SKAction waitForDuration:0.3];

        SKAction *square = [SKAction sequence:@[leftDown,wait1,
                                                down,wait2,
                                                rightDown,wait3,
                                                zero,wait4,]];
        [labelNode runAction:[SKAction repeatActionForever:square]];

        SKAction *fadeIn = [SKAction fadeInWithDuration:0.25];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3];

        [labelNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeIn,fadeOut]]]];

    }

    SKNode *node = [self childNodeWithName:@"helloNode"];

    if (node)
    {
        node.name = nil;

        SKAction *moveUp = [SKAction moveByX:0 y:100 duration:0.5];
        SKAction *zoom = [SKAction scaleTo:2.0 duration:0.25];
        SKAction *pause = [SKAction waitForDuration:0.5];
        SKAction *fadeAway = [SKAction fadeInWithDuration:0.25];
        SKAction *remove = [SKAction removeFromParent];

        SKAction *moveSequence = [SKAction sequence:@[moveUp,
                                                      zoom,
                                                      pause,
                                                      fadeAway,
                                                      remove]];
        [node runAction:moveSequence completion:^{
//            SpaceshipScene *spaceshipScene = [[SpaceshipScene alloc]initWithSize:self.size];
//            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
//            [self.view presentScene:spaceshipScene transition:doors];
        }];
    }
}

@end
