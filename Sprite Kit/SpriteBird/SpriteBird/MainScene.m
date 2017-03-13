//
//  MainScene.m
//  SpriteBird
//
//  Created by STMBP on 2017/3/13.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "MainScene.h"

#define wall_w 40
#define timeinterval_movewall 4.0f
#define hero_fly        @"fly"

#define dust_add        @"add_dust"
#define dust_w      20
#define dust_h      1
#define dust_w_min  2
#define dust_w_max  5

@interface MainScene ()
@property (strong, nonatomic) SKAction *actionMoveWall;
@property (strong, nonatomic) SKAction *actionMoveHead;

@property (strong, nonatomic) SKSpriteNode *hero;
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

            /// add dust
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(addDustNode) onTarget:self],[SKAction waitForDuration:0.3]]]]];
    }
    return self;
}
- (void)addDustNode
{
    CGFloat fDustNodeW = (arc4random()%(dust_w_max-dust_w_min+1)+dust_w_min)*dust_w;
    SKSpriteNode *nodeDust = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1] size:CGSizeMake(fDustNodeW, dust_h)];
    nodeDust.anchorPoint = CGPointMake(0, 0);
    nodeDust.name = @"dust";
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
- (SKAction *)getFlyAction
{
    SKAction *flyUp = [SKAction moveToY:self.hero.position.y + 10 duration:0.3f];
    flyUp.timingMode = SKActionTimingEaseOut;
    SKAction *flyDown = [SKAction moveToY:self.hero.position.y - 10 duration:0.3f];
    flyDown.timingMode = SKActionTimingEaseOut;
    SKAction *fly = [SKAction sequence:@[flyUp, flyDown]];
    return fly;
}
@end
