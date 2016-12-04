//
//  GameScene.m
//  Wet Koala Demo
//
//  Created by STMBP on 2016/12/2.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()<SKPhysicsContactDelegate>
@property BOOL contentCreated;
@property (nonatomic) SKTextureAtlas *atlas;
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
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    self.atlas = [SKTextureAtlas atlasNamed:@"sprite"];
    
    //set background
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    //set cloud
    SKSpriteNode *cloudDark = [SKSpriteNode spriteNodeWithImageNamed:@"cloud-dark"];
    cloudDark.anchorPoint = CGPointMake(0.5, 1.0);
    cloudDark.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:cloudDark];

    SKSpriteNode *cloudBright =  [SKSpriteNode spriteNodeWithImageNamed:@"cloud-bright"];
    cloudBright.anchorPoint = CGPointMake(0.5, 1.0);
    cloudBright.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:cloudBright];
    
    
    SKAction *cloudMoveLeftRight = [SKAction repeatActionForever:[SKAction sequence:@[
                                                                                      [SKAction moveByX:30.0 y:0.0 duration:3.0],
                                                                                      [SKAction moveByX:-30.0 y:0.0 duration:3.0]]]];
    
    SKAction *cloudMoveUpDown = [SKAction repeatActionForever:[SKAction sequence:@[
                                                                                   [SKAction moveByX:0.0 y:30.0 duration:2.5],
                                                                                   [SKAction moveByX:0.0 y:-30.0 duration:2.5]]]];

    [cloudDark   runAction:cloudMoveLeftRight];
    [cloudBright runAction:cloudMoveUpDown];
    
    // set ground
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    ground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) - ground.size.height/4);
    ground.anchorPoint = CGPointMake(0.5, 0.0);
    [self addChild:ground];
}
#pragma mark - SKPhysicsContactDelegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    
}
@end
