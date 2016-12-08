//
//  GameScene.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/8.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameScene.h"
#import "SharedAtlas.h"
#import "FoePlane.h"

typedef NS_ENUM(uint32_t, PGRoleCategory)
{
    PGRoleCategoryBullet            = 1,
    PGRoleCategoryFoePlane          = 4,
    PGRoleCategoryPlayerPlane       = 8
};
static int iSmallPlaneH = 14;
static int iMediumPlaneH = 33;
static int iBigPlaneH = 86;

@interface GameScene ()<SKPhysicsContactDelegate>
@property (assign, nonatomic) BOOL contentCreated;
@property (assign, nonatomic) int iMoveBgPosition;
@property (strong, nonatomic) SKSpriteNode *background1;
@property (strong, nonatomic) SKSpriteNode *background2;
@property (strong, nonatomic) SKSpriteNode *playerPlane;

@property (assign, nonatomic) NSInteger timeSmallPlane;  //25
@property (assign, nonatomic) NSInteger timeMediumPlane; //400
@property (assign, nonatomic) NSInteger timeBigPlane;    //700
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
    [self initFiringBullets];

    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
}
- (void)initFoePlane
{
    self.timeSmallPlane++;
    self.timeMediumPlane++;
    self.timeBigPlane++;

    if (self.timeSmallPlane > 25)
    {
        FoePlane *foePlane = [self createFoePlaneWithType:PGFoePlaneTypeSmall];
        [self addChild:foePlane];

        float speed = randf(3, 5);
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:-iSmallPlaneH duration:speed],[SKAction removeFromParent]]]];
        self.timeSmallPlane = 0;
    }

    if (self.timeMediumPlane > 400)
    {
        FoePlane *foePlane = [self createFoePlaneWithType:PGFoePlaneTypeMedium];
        [self addChild:foePlane];

        float speed = randf(3.5, 6);
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:-iMediumPlaneH duration:speed],[SKAction removeFromParent]]]];
        self.timeMediumPlane = 0;
    }

    if (self.timeBigPlane > 700)
    {
        FoePlane *foePlane = [self createFoePlaneWithType:PGFoePlaneTypeBig];
        [self addChild:foePlane];

        float speed = randf(3.5, 8);
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:-iBigPlaneH duration:speed],[SKAction removeFromParent]]]];
        self.timeBigPlane = 0;
    }
}
- (FoePlane *)createFoePlaneWithType:(PGFoePlaneType)type
{
    FoePlane *foePlane = nil;
    float fFoePositionX = 0;
    switch (type)
    {
        case PGFoePlaneTypeSmall:
            fFoePositionX = randf(19, self.size.width-19);
            foePlane = [FoePlane createSmallPlane];
            break;
        case PGFoePlaneTypeMedium:
            fFoePositionX = randf(23, self.size.width-23);
            foePlane = [FoePlane createMediumPlane];
            break;
        case PGFoePlaneTypeBig:
            fFoePositionX = randf(56, self.size.width-56);
            foePlane = [FoePlane createBigPlane];
            break;
        default:
            break;
    }
    foePlane.zPosition = 1;
    foePlane.physicsBody.categoryBitMask = PGRoleCategoryFoePlane;
    foePlane.physicsBody.contactTestBitMask = PGRoleCategoryPlayerPlane;
    foePlane.physicsBody.collisionBitMask = PGRoleCategoryBullet;
    foePlane.position = CGPointMake(fFoePositionX, self.size.height);
    return foePlane;
}
- (void)initFiringBullets
{
    SKAction *actionCreateBullet = [SKAction runBlock:^{
        [self createBullet];
    }];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[actionCreateBullet,
                                                                       [SKAction waitForDuration:k_TimeInterval_bullet_Fire]]]]];
}
- (void)createBullet
{
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypeBullet1]];
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
    bullet.physicsBody.contactTestBitMask = PGRoleCategoryFoePlane;
    bullet.physicsBody.categoryBitMask = PGRoleCategoryBullet;
    bullet.physicsBody.collisionBitMask = 0;
    bullet.zPosition = 1;
    bullet.position = CGPointMake(self.playerPlane.position.x,
                                  self.playerPlane.size.height/2.+self.playerPlane.position.y);
    [self addChild:bullet];

    [bullet runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.playerPlane.position.x, self.size.height+bullet.size.height) duration:k_TimeInterval_bullet_Move],
                                           [SKAction removeFromParent]]]];
        // add bullet music
    [self runAction:[SKAction playSoundFileNamed:@"bullet.mp3" waitForCompletion:YES]];
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
    self.background1 = [SKSpriteNode spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypeBackground] size:self.size];
    self.background1.position = CGPointMake(self.size.width/2., 0);
    self.background1.anchorPoint = CGPointMake(0.5, 0);
    self.background1.zPosition = 0;
    [self addChild:self.background1];

    self.background2 = [SKSpriteNode spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypeBackground] size:self.size];
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
    self.background2.position = CGPointMake(self.size.width/2., self.iMoveBgPosition-1);
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
    [self initFoePlane];
}

#pragma mark - responder
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    translation = CGPointMake(translation.x, -translation.y);
    [self panForTranslation:translation];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}
- (void)panForTranslation:(CGPoint)pointTran
{
    float shipWTemp = self.playerPlane.frame.size.width/2.;
    float shipHTemp = self.playerPlane.frame.size.height/2.;

    if (self.playerPlane.position.x+pointTran.x>=shipWTemp && self.playerPlane.position.x+pointTran.x < self.frame.size.width-shipWTemp
        &&self.playerPlane.position.y+pointTran.y>=shipHTemp && self.playerPlane.position.y+pointTran.y < self.frame.size.height-shipHTemp
        )
    {
        self.playerPlane.position = CGPointMake(self.playerPlane.position.x+pointTran.x, self.playerPlane.position.y+pointTran.y);
    }
        ///需要进一步交互
}
    /// 取随机数
static inline CGFloat skRandf()
{
    return rand()/(CGFloat)RAND_MAX;
}
static inline CGFloat randf(CGFloat low,CGFloat high)
{
    return skRandf()*(high-low)+low;
}
@end
