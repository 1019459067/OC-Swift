//
//  HelloScene.m
//  SpriteKitSimpleGame
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
        [self createSceneContents];
        self.contentCreated = YES;
    }
}
- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild:[self newHelloNode]];
}
- (SKLabelNode *)newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithText:@"Chalkduster"];
    helloNode.text = @"hello,sensetime";
    helloNode.fontSize = 42;
    helloNode.name = @"helloName";
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    return helloNode;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SKNode *helloNode = [self childNodeWithName:@"helloName"];
    if (helloNode)
    {
        helloNode.name = nil;
        SKAction *moveup = [SKAction moveByX:0 y:100 duration:0.5];
        SKAction *zoom = [SKAction scaleTo:2 duration:0.25];
        SKAction *pause = [SKAction waitForDuration:0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
        [helloNode runAction:moveSequence completion:^{
            SpaceshipScene *spaceShipScence = [[SpaceshipScene alloc]initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:spaceShipScence transition:doors];
        }];
    }
}
@end
