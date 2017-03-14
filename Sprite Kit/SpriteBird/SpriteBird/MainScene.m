//
//  MainScene.m
//  SpriteBird
//
//  Created by STMBP on 2017/3/13.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "MainScene.h"

#define ground_h 20

#define wall_w          40
#define nodeName_wall   @"wall"
#define wall_move       @"move_wall"
#define wall_add        @"add_wall"

#define nodeName_hole   @"hole"

#define timeinterval_movewall   4.0f
#define timeinterval_addwall    2.0f

#define hero_fly        @"fly"

#define nodeName_dust   @"dust"
#define dust_add        @"add_dust"
#define dust_w      20
#define dust_h      1
#define dust_w_min  2
#define dust_w_max  5

@interface MainScene ()
{
    BOOL _bGameStart;
    BOOL _bGameOver;
}
@property (strong, nonatomic) SKAction *actionMoveWall;
@property (strong, nonatomic) SKAction *actionMoveHead;

@property (strong, nonatomic) SKSpriteNode *hero;
@property (strong, nonatomic) SKSpriteNode *ground;
@end
@implementation MainScene
- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [UIColor whiteColor];

            /// wall move action
        self.actionMoveWall = [SKAction moveToX:-wall_w duration:timeinterval_movewall];

            /// head move action
        SKAction *actionUpHead = [SKAction rotateByAngle:M_PI/6. duration:0.2];
        actionUpHead.timingMode = SKActionTimingEaseOut;
        SKAction *actionDownHead = [SKAction rotateByAngle:-M_PI/2. duration:0.8];
        self.actionMoveHead = [SKAction sequence:@[actionUpHead,actionDownHead]];

            /// add hero
        [self addHeroNode];

            /// add ground
        [self addGroundNode];

            /// add dust
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(addDustNode) onTarget:self],[SKAction waitForDuration:0.3]]]]];
    }
    return self;
}
- (void)addGroundNode
{
    self.ground = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:34/255. green:166/255. blue:159/255. alpha:1] size:CGSizeMake(self.frame.size.width, ground_h)];
    self.ground.anchorPoint = CGPointMake(0, 0);
    self.ground.position = CGPointMake(0, 0);
    [self addChild:self.ground];
}
- (void)addDustNode
{
    CGFloat fDustNodeW = (arc4random()%(dust_w_max-dust_w_min+1)+dust_w_min)*dust_w;
    SKSpriteNode *nodeDust = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1] size:CGSizeMake(fDustNodeW, dust_h)];
    nodeDust.anchorPoint = CGPointMake(0, 0);
    nodeDust.name = nodeName_dust;
    nodeDust.position = CGPointMake(self.frame.size.width, arc4random()%(int)(self.frame.size.height/2)+self.frame.size.height/2.);
    [nodeDust runAction:[SKAction moveToX:-fDustNodeW duration:1]];
    [self addChild:nodeDust];
}
- (void)addHeroNode
{
    self.hero = [[SKSpriteNode alloc]initWithColor:[UIColor purpleColor] size:CGSizeMake(40, 30)];
    self.hero.anchorPoint = CGPointMake(0.5, 0.5);
    self.hero.position = CGPointMake(self.frame.size.width/3.0, CGRectGetMidY(self.frame));
    [self addChild:self.hero];

    [self.hero runAction:[SKAction repeatActionForever:[self getFlyAction]] withKey:hero_fly];
}
- (void)addWallNode
{
    CGFloat spaceH = self.frame.size.height-ground_h;
#warning <#message#>
    CGFloat holeLength = self.hero.size.width * 5;
    int holePosition = arc4random()%(int)((spaceH-holeLength)/self.hero.size.height);

    CGFloat x = self.frame.size.width;
        /// 上半部分
    CGFloat upHeight = holePosition * self.hero.size.height;
    if (upHeight > 0)
    {
        SKSpriteNode *nodeWallUp = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(wall_w, upHeight)];
        nodeWallUp.anchorPoint = CGPointMake(0, 0);
        nodeWallUp.position = CGPointMake(x, self.frame.size.height-upHeight);
        nodeWallUp.name = nodeName_wall;

        [nodeWallUp runAction:self.actionMoveWall withKey:wall_move];
        [self addChild:nodeWallUp];
    }
        /// 下半部分
    CGFloat downHeight = spaceH - upHeight - holeLength;
    if (downHeight > 0)
    {
        SKSpriteNode *nodeWallDown = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(wall_w, downHeight)];
        nodeWallDown.anchorPoint = CGPointMake(0, 0);
        nodeWallDown.position = CGPointMake(x, ground_h);
        nodeWallDown.name = nodeName_wall;

        [nodeWallDown runAction:self.actionMoveWall withKey:wall_move];
        [self addChild:nodeWallDown];
    }
        /// 中空部分
    SKSpriteNode *hole = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:CGSizeMake(wall_w, holeLength)];
    hole.anchorPoint = CGPointMake(0, 0);
    hole.position = CGPointMake(x, self.frame.size.height-upHeight-holeLength);
    hole.name = nodeName_hole;

    [hole runAction:self.actionMoveWall withKey:wall_move];
    [self addChild:hole];
}
- (SKAction *)getFlyAction
{
    SKAction *actionflyUp = [SKAction moveToY:self.hero.position.y + 10 duration:0.3f];
    actionflyUp.timingMode = SKActionTimingEaseOut;
    SKAction *actionflyDown = [SKAction moveToY:self.hero.position.y - 10 duration:0.3f];
    actionflyDown.timingMode = SKActionTimingEaseOut;
    SKAction *actionfly = [SKAction sequence:@[actionflyUp, actionflyDown]];
    return actionfly;
}

- (void)startGame
{
    _bGameStart = YES;

    [self removeActionForKey:dust_add];

        /// hero
    self.hero.physicsBody.affectedByGravity = YES;
    [self.hero removeActionForKey:hero_fly];

        /// add wall
    SKAction *actionWallAdd = [SKAction sequence:@[[SKAction performSelector:@selector(addWallNode) onTarget:self],[SKAction waitForDuration:timeinterval_addwall]]];
    [self runAction:[SKAction repeatActionForever:actionWallAdd] withKey:wall_add];
}
- (void)update:(NSTimeInterval)currentTime
{
    __block int iCountWall = 0;
    [self enumerateChildNodesWithName:nodeName_wall usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (iCountWall>=2)
        {
            *stop = YES;
            return;
        }
        if (node.position.x <= -wall_w)
        {
            iCountWall++;
            [node removeFromParent];
        }
    }];
    [self enumerateChildNodesWithName:nodeName_dust usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x<= -node.frame.size.width)
        {
            [node removeFromParent];
        }
    }];
    [self enumerateChildNodesWithName:nodeName_hole usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x<= -wall_w)
        {
            [node removeFromParent];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_bGameOver)
    {
        return;
    }
    if (!_bGameStart)
    {
        [self startGame];
    }
}
@end
