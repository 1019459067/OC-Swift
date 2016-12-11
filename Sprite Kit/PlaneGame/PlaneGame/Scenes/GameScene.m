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
#import "ButtonNode.h"
#import "GameViewController.h"

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

@property (strong, nonatomic) SKAction *actionHitBigPlane;
@property (strong, nonatomic) SKAction *actionHitMediumPlane;
@property (strong, nonatomic) SKAction *actionHitSmallPlane;

@property (strong, nonatomic) SKAction *actionBlownUpBigPlane;
@property (strong, nonatomic) SKAction *actionBlownUpMediumPlane;
@property (strong, nonatomic) SKAction *actionBlownUpSmallPlane;

@property (strong, nonatomic) ButtonNode *buttonPause;
@property (strong, nonatomic) SKLabelNode *labelScore;
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
    [self createElements];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restart) name:k_Noti_Restart object:nil];
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
}
- (void)createElements
{
    [self initBackground];
    [self initPlayerPlane];
    [self initFiringBullets];
    [self initAction];
    [self initPauseButton];
    [self initScore];
}
- (void)initScore
{
    self.labelScore = [[SKLabelNode alloc]initWithFontNamed:MarkerFelt_Thin];
    self.labelScore.text = @"00000";
    self.labelScore.fontColor = [SKColor blackColor];
    self.labelScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.labelScore.position = CGPointMake(70, CGRectGetMinY(self.buttonPause.frame));
    [self addChild:self.labelScore];
}
- (void)initPauseButton
{
    self.buttonPause = [[ButtonNode alloc]initWithDefaultTexture:[SharedAtlas textureButtonPauseDefault] andTouchedTexture:[SharedAtlas textureButtonPauseHight]];
    self.buttonPause.zPosition = 3;
    self.buttonPause.position = CGPointMake(self.buttonPause.frame.size.width/2.+20, self.size.height-(self.buttonPause.frame.size.height/2.+20));
    __weak typeof(GameScene *) weakSelf = self;
    [self.buttonPause setMethod:^{
        [weakSelf didPause:weakSelf.buttonPause];
    }];
    [self addChild:self.buttonPause];
}
- (void)didPause:(ButtonNode *)node
{
    if (!self.isPaused)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:k_Noti_Pause object:nil];
    }
}

- (void)restart
{
    [self removeAllChildren];
    [self removeAllActions];

    [self createElements];
}
- (void)initAction
{
    self.actionHitBigPlane = [SharedAtlas actionHittedWithFoePlaneType:PGFoePlaneTypeBig];
    self.actionHitMediumPlane = [SharedAtlas actionHittedWithFoePlaneType:PGFoePlaneTypeMedium];
    self.actionHitSmallPlane = [SharedAtlas actionHittedWithFoePlaneType:PGFoePlaneTypeSmall];

    self.actionBlownUpBigPlane = [SharedAtlas actionBlowupWithFoePlaneType:PGFoePlaneTypeBig];
    self.actionBlownUpMediumPlane = [SharedAtlas actionBlowupWithFoePlaneType:PGFoePlaneTypeMedium];
    self.actionBlownUpSmallPlane = [SharedAtlas actionBlowupWithFoePlaneType:PGFoePlaneTypeSmall];
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
        if ([[DefaultValue shared].strSound intValue])
        {
            [self runAction:[SKAction playSoundFileNamed:@"enemy2_out.mp3" waitForCompletion:YES] withKey:k_Music_FoePlane];
        }
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
    foePlane.physicsBody.contactTestBitMask = PGRoleCategoryBullet;
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
    bullet.physicsBody.categoryBitMask = PGRoleCategoryBullet;
    bullet.physicsBody.contactTestBitMask = PGRoleCategoryFoePlane;
    bullet.physicsBody.collisionBitMask = PGRoleCategoryFoePlane;
    bullet.zPosition = 1;
    bullet.position = CGPointMake(self.playerPlane.position.x,
                                  self.playerPlane.size.height/2.+self.playerPlane.position.y);
    [self addChild:bullet];

    [bullet runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(self.playerPlane.position.x, self.size.height+bullet.size.height) duration:k_TimeInterval_bullet_Move],
                                           [SKAction removeFromParent]]]];
        // add bullet music
    if ([[DefaultValue shared].strSound intValue])
    {
        [self runAction:[SKAction playSoundFileNamed:@"bullet.mp3" waitForCompletion:YES] withKey:k_Music_Bullet];
    }
}
- (void)initPlayerPlane
{
    self.playerPlane = [SKSpriteNode spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypePlayerPlane1]];
    self.playerPlane.position = CGPointMake(self.size.width/2., self.playerPlane.size.height/2.);
    self.playerPlane.zPosition = 1;
    self.playerPlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.playerPlane.size];
    self.playerPlane.physicsBody.categoryBitMask = PGRoleCategoryPlayerPlane;
    self.playerPlane.physicsBody.contactTestBitMask = PGRoleCategoryFoePlane;
    self.playerPlane.physicsBody.collisionBitMask = 0;
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
    if ([[DefaultValue shared].strSound intValue])
    {
        [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"game_music.mp3" waitForCompletion:YES]] withKey:k_Music_Background];
    }

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

- (void)foePlaneCollisionnAnimationWith:(FoePlane *)foePlane
{
    if (![foePlane actionForKey:@"dieAction"])
    {
        SKAction *actionHit = nil;
        SKAction *actionBlownUp = nil;
        NSString *strSoundPath = nil;
        switch (foePlane.type)
        {
            case PGFoePlaneTypeBig:
            {
                foePlane.ph--;
                actionHit = self.actionHitBigPlane;
                actionBlownUp = self.actionBlownUpBigPlane;
                strSoundPath = @"enemy2_down.mp3";
            }
                break;
            case PGFoePlaneTypeMedium:
            {
                foePlane.ph--;
                actionHit = self.actionHitMediumPlane;
                actionBlownUp = self.actionBlownUpMediumPlane;
                strSoundPath = @"enemy3_down.mp3";
            }
                break;
            case PGFoePlaneTypeSmall:
            {
                foePlane.ph--;
                actionHit = self.actionHitSmallPlane;
                actionBlownUp = self.actionBlownUpSmallPlane;
                strSoundPath = @"enemy1_down.mp3";
            }
                break;
            default:
                break;
        }

        if (!foePlane.ph)
        {
            [foePlane removeAllActions];
            [foePlane runAction:actionBlownUp withKey:@"dieAction"];
            if ([[DefaultValue shared].strSound intValue])
            {
                [foePlane runAction:[SKAction playSoundFileNamed:strSoundPath waitForCompletion:YES] withKey:k_Music_FoePlane_Down];
            }
            [self updateScore:foePlane.type];
        }else
        {
            [foePlane runAction:actionHit];
        }
    }
}
- (void)updateScore:(PGFoePlaneType)type
{
    int iScore = 0;
    switch (type)
    {
        case PGFoePlaneTypeBig:
            iScore = 6;
            break;
        case PGFoePlaneTypeMedium:
            iScore = 3;
            break;
        case PGFoePlaneTypeSmall:
            iScore = 1;
            break;
        default:
            break;
    }
    [self.labelScore runAction:[SKAction runBlock:^{
        self.labelScore.text = [NSString stringWithFormat:@"%05d",self.labelScore.text.intValue+iScore];
    }]];
}
- (void)playerPlaneCollisionnAnimationWith:(SKSpriteNode *)playerPlane
{
    [self removeAllActions];
    [self.buttonPause removeFromParent];
    [self.labelScore removeFromParent];

    SKAction *actionMusic = [SKAction playSoundFileNamed:@"game_over.mp3" waitForCompletion:YES];
    SKAction *actionOver = [SKAction runBlock:^{
        SKLabelNode *nodeLabel = [SKLabelNode labelNodeWithFontNamed:MarkerFelt_Thin];
        nodeLabel.text = @"GameOver";
        nodeLabel.zPosition = 2;
        nodeLabel.fontColor = [SKColor blackColor];
        nodeLabel.fontSize = 42;
        nodeLabel.position = CGPointMake(self.size.width/2 , self.size.height/2 + 50);
        [self addChild:nodeLabel];

        SKLabelNode *nodeLabelScore = [[SKLabelNode alloc]init];
        nodeLabelScore.text = [NSString stringWithFormat:@"Your score: %d",self.labelScore.text.intValue];
        nodeLabelScore.zPosition = 2;
        nodeLabelScore.fontColor = [SKColor blackColor];
        nodeLabelScore.fontSize = 25;
        nodeLabelScore.position = CGPointMake(self.size.width/2 , self.size.height/2 - 45);
        [self addChild:nodeLabelScore];
    }];

    if ([[DefaultValue shared].strSound intValue])
    {
        [playerPlane runAction:[SharedAtlas actionBlowupWithPlayerPlane] completion:^{
            [self runAction:[SKAction sequence:@[actionMusic,actionOver]] completion:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:k_Noti_GameOver object:nil];
            }];
        }];
    }else
    {
        [playerPlane runAction:[SharedAtlas actionBlowupWithPlayerPlane] completion:^{
            [self runAction:[SKAction sequence:@[actionOver]] completion:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:k_Noti_GameOver object:nil];
            }];
        }];    }

}
#pragma mark - SKPhysicsContactDelegate
/*
 http://blog.csdn.net/u010019717/article/details/32942641
 */
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask & PGRoleCategoryFoePlane
        ||contact.bodyB.categoryBitMask & PGRoleCategoryFoePlane)
    {
        FoePlane *foePlane = (contact.bodyA.categoryBitMask & PGRoleCategoryFoePlane) ? (FoePlane*)contact.bodyA.node:(FoePlane*)contact.bodyB.node;
        [self foePlaneCollisionnAnimationWith:foePlane];
    }

    if (contact.bodyA.categoryBitMask & PGRoleCategoryPlayerPlane
        ||contact.bodyB.categoryBitMask & PGRoleCategoryPlayerPlane)
    {
        SKSpriteNode *playerPlane = (contact.bodyA.categoryBitMask & PGRoleCategoryPlayerPlane) ? (SKSpriteNode*)contact.bodyA.node:(SKSpriteNode*)contact.bodyB.node;
        [self playerPlaneCollisionnAnimationWith:playerPlane];
    }

    if (contact.bodyA.categoryBitMask & PGRoleCategoryBullet
        ||contact.bodyB.categoryBitMask & PGRoleCategoryBullet)
    {
        SKSpriteNode *bullet = (contact.bodyA.categoryBitMask & PGRoleCategoryBullet) ? (SKSpriteNode*)contact.bodyA.node:(SKSpriteNode*)contact.bodyB.node;
        [bullet removeFromParent];
    }
}

#pragma mark - responder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [ButtonNode doButtonsActionBegan:self touches:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [ButtonNode doButtonsActionEnded:self touches:touches withEvent:event];
}
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    if (self.isPaused)
    {
        return;
    }
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
- (void)update:(NSTimeInterval)currentTime
{
    [self scrollBackground];
    [self initFoePlane];

    GameViewController *vc = (GameViewController *) self.view.window.rootViewController;

    float iYaw = vc.yawValue;
    if (iYaw>0)
    {
        iYaw = sqrt(iYaw);
    }else
    {
        iYaw = -sqrt(fabs(iYaw));
    }
//    NSLog(@"yawValue    : %f   %f",vc.yawValue,iYaw);

//    NSLog(@"yawValue    : %f",vc.yawValue);
//    NSLog(@"pitchValue  : %f",vc.pitchValue);

    float fNodeW = self.playerPlane.frame.size.width/2.;
    float fNodeH = self.playerPlane.frame.size.height/2.;

    if (fabs(vc.yawValue)<=30)
    {
        if (self.playerPlane.position.x+vc.yawValue>=fNodeW && self.playerPlane.position.x+vc.yawValue < self.frame.size.width-fNodeW)
        {
            self.playerPlane.position = CGPointMake(self.playerPlane.position.x+vc.yawValue, self.playerPlane.position.y);
        }
    }

    if (fabs(vc.pitchValue)<=17)
    {
        if (self.playerPlane.position.y-vc.pitchValue>=fNodeH && self.playerPlane.position.y-vc.pitchValue < self.frame.size.height-fNodeH)
        {
            self.playerPlane.position = CGPointMake(self.playerPlane.position.x, self.playerPlane.position.y-vc.pitchValue);
        }
    }

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
