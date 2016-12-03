//
//  HelloScene.m
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/3.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "HelloScene.h"

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
    return labelNode;
}

@end
