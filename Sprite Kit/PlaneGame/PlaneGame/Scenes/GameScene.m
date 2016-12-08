//
//  GameScene.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/8.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameScene.h"
#import "SharedAtlas.h"

typedef NS_ENUM(uint32_t, PGRoleCategory)
{
    PGRoleCategoryBullet            = 1,
    PGRoleCategoryFoePlane          = 4,
    PGRoleCategoryPlayerPlane       = 8
};
@interface GameScene ()<SKPhysicsContactDelegate>
@property (assign, nonatomic) BOOL contentCreated;
@property (assign, nonatomic) int iMoveBgPosition;
@property (strong, nonatomic) SKSpriteNode *background1;
@property (strong, nonatomic) SKSpriteNode *background2;
@property (strong, nonatomic) SKSpriteNode *playerPlane;
@end
@implementation GameScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.contentCreated = YES;
        [self createScenesContents];
    }
}
- (void)createScenesContents
{
    self.backgroundColor = [SKColor darkGrayColor];

        /// 物理模拟
    [self initPhysicsWorld];
    [self initBackground];
    [self initPlayerPlane];
}
- (void)initPlayerPlane
{
    self.playerPlane = [SKSpriteNode spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypePlayerPlane1]];
    self.playerPlane.position = CGPointMake(self.size.width/2., 50);
    self.playerPlane.zPosition = 1;
    self.playerPlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.playerPlane.size];
    self.playerPlane.physicsBody.collisionBitMask = 0;
    self.playerPlane.physicsBody.categoryBitMask = PGRoleCategoryPlayerPlane;
    self.playerPlane.physicsBody.contactTestBitMask = PGRoleCategoryFoePlane;
    [self addChild:self.playerPlane];

    [self.playerPlane runAction:[SharedAtlas playerPlaneAction]];
}
- (void)initBackground
{
    self.background1 = [SKSpriteNode spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypeBackground]];
    self.background1.position = CGPointMake(self.size.width/2., 0);
    self.background1.anchorPoint = CGPointMake(0.5, 0);
    self.background1.zPosition = 0;
    [self addChild:self.background1];

    self.background2 = [SKSpriteNode spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypeBackground]];
    self.background2.position = CGPointMake(self.size.width/2., self.size.height);
    self.background2.anchorPoint = CGPointMake(0.5, 0);
    self.background2.zPosition = 0;
    [self addChild:self.background2];

        /// add back ground music
    [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"game_music.mp3" waitForCompletion:YES]]];

    self.iMoveBgPosition = self.size.height;
}
- (void)scrollBackground
{
    self.iMoveBgPosition--;
    if (self.iMoveBgPosition <= 0)
    {
        self.iMoveBgPosition = self.size.height;
    }
    self.background1.position = CGPointMake(self.size.width/2., self.iMoveBgPosition-self.size.height);
    self.background2.position = CGPointMake(self.size.width/2., self.iMoveBgPosition);
}
- (void)initPhysicsWorld
{
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
}

#pragma mark - SKPhysicsContactDelegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{

}
- (void)update:(NSTimeInterval)currentTime
{
    [self scrollBackground];
}
@end
