//
//  HelloScene.m
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/3.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "HelloScene.h"
#import "SpaceshipScene.h"

@interface HelloScene ()
@property BOOL contentCreated;
@end

@implementation HelloScene
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
            SpaceshipScene *spaceshipScene = [[SpaceshipScene alloc]initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:spaceshipScene transition:doors];
        }];

    }
}

@end
