//
//  GameScene.m
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/5.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameScene.h"
#import "ButtonNode.h"
#import "HomeScene.h"
#import "GameViewController.h"

/*
 http://blog.csdn.net/kobbbb/article/details/9093601
 */
@interface GameScene ()
@property (assign, nonatomic) BOOL contentCreated;
@property (weak, nonatomic) SKLabelNode *labelNumber;
@property (weak, nonatomic) SKSpriteNode *ship;
@property (strong, nonatomic) NSMutableArray *nearbyArray;
@end
@implementation GameScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.nearbyArray=[[NSMutableArray alloc]init];
        [self addBackground];

            // add gesture
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        [[self view] addGestureRecognizer:gestureRecognizer];

        self.contentCreated = YES;
        [self createSceneContents];
    }
}
- (void)addBackground
{
    /*第一个场景背景节点*/
    SKTexture *farTexture = [SKTexture textureWithImageNamed:@"background"];
    SKSpriteNode  *farTextureSpriteOne = [SKSpriteNode spriteNodeWithTexture:farTexture size:self.size];
    farTextureSpriteOne.zPosition=0;
    farTextureSpriteOne.position=CGPointMake(self.frame.size.width/2, self.frame.size.height/2 );
    
    /*第二个场景背景节点*/
    SKTexture *farTextureTwo = [SKTexture textureWithImageNamed:@"background"];
    SKSpriteNode  *farTextureSpriteTwo = [SKSpriteNode spriteNodeWithTexture:farTextureTwo size:self.size];
    farTextureSpriteTwo.zPosition=0;
    farTextureSpriteTwo.position=CGPointMake(farTextureSpriteOne.position.x, -(self.frame.size.height/2-10));
    
    
    
    /*第三个场景背景节点*/
    SKTexture *farTextureThree = [SKTexture textureWithImageNamed:@"background"];
    
    SKSpriteNode  *farTextureSpriteThree =[SKSpriteNode spriteNodeWithTexture:farTextureThree size:self.size];
    
    farTextureSpriteThree.zPosition=0;
    farTextureSpriteThree.position=CGPointMake(farTextureSpriteOne.position.x, -(self.frame.size.height/2+self.frame.size.height-20));
    
    
    
    
    [self addChild:farTextureSpriteOne];
    [self addChild:farTextureSpriteTwo];
    [self addChild:farTextureSpriteThree];
    
    /*把三个场景背景节点加到一个数组中去，等会滚动之后，才好快速获取每个节点，重置postion*/
    [self.nearbyArray addObject:farTextureSpriteOne];
    [self.nearbyArray addObject:farTextureSpriteTwo];
    [self.nearbyArray addObject:farTextureSpriteThree];

}
- (void)createSceneContents
{
        /// back button
    ButtonNode *back = [[ButtonNode alloc]init];
    back.text = @"返回";
    back.fontColor = [SKColor whiteColor];
    back.position = CGPointMake(40, self.size.height-50);
    [back didClickedMethod:^{
        [self backHome];
    }];
    [self addChild:back];

    [self newShip];

        /// add rocks
    SKAction *makeRocks = [SKAction sequence:@[[SKAction performSelector:@selector(addRocks) onTarget:self],
                                               [SKAction waitForDuration:0.1 withRange:0.01]]];
    [self runAction:[SKAction repeatActionForever:makeRocks]];
}
static inline CGFloat skRandf()
{
    return rand()/(CGFloat)RAND_MAX;
}
static inline CGFloat skRand(CGFloat start,CGFloat end)
{
    return skRandf()*(end-start)+start;
}
- (void)addRocks
{
    SKSpriteNode *rock = [[SKSpriteNode alloc]initWithColor:[SKColor brownColor] size:CGSizeMake(8, 8)];
    rock.name = @"rock";
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    rock.position = CGPointMake(skRand(0, self.size.height), self.size.height);
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    [self addChild:rock];
}
- (void)newShip
{
    SKSpriteNode *hull = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"hero_fly"]];
    hull.name = @"ship";
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    hull.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:hull];
    self.ship = hull;

//    self.lastYaw = hull.position.x;

        ///add light
    SKSpriteNode *l1 = [self newLightWithPosition:CGPointMake(-18, 8)];
    [hull addChild:l1];

    SKSpriteNode *l2 = [self newLightWithPosition:CGPointMake(18, 8)];
    [hull addChild:l2];

        //add label
    SKLabelNode *labelNumber = [[SKLabelNode alloc]init];
    labelNumber.text = @"sensetime";
    labelNumber.fontColor = [SKColor yellowColor];
    labelNumber.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*1/8.);
    [self addChild:labelNumber];
    self.labelNumber = labelNumber;

}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    translation = CGPointMake(translation.x, -translation.y);
    [self panForTranslation:translation];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}
- (void)panForTranslation:(CGPoint)pointTran
{
    float shipWTemp = self.ship.frame.size.width/2.;
    float shipHTemp = self.ship.frame.size.height/2.;

    if (self.ship.position.x+pointTran.x>=shipWTemp && self.ship.position.x+pointTran.x < self.frame.size.width-shipWTemp
        &&self.ship.position.y-pointTran.y>=shipHTemp && self.ship.position.y-pointTran.y < self.frame.size.height-shipHTemp
        )
    {
        self.ship.position = CGPointMake(self.ship.position.x+pointTran.x, self.ship.position.y+pointTran.y);
    }
}
- (SKSpriteNode *)newLightWithPosition:(CGPoint)point
{
    SKSpriteNode *light = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(12, 2)];
    light.position = point;
    light.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:light.size];
    light.physicsBody.dynamic = NO;

        /// add action
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.38];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.38];

    [light runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeIn,fadeOut]]]];
    return light;
}
- (void)backHome
{
    HomeScene *scene = [[HomeScene alloc]initWithSize:self.size];
    SKTransition *tran = [SKTransition doorsCloseVerticalWithDuration:0.5];
    [self.view presentScene:scene transition:tran];
    
    GameViewController *vc = (GameViewController *) self.view.window.rootViewController;
    [vc stopTime];
    [vc stopLocalCam];
}

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.y<0)
        {
            [node removeFromParent];
        }
    }];
}

/*设置背景图片滚动的方法*/
- (void)BackMove:(CGFloat)moveSpeed
{
    
    for (int i=0; i<self.nearbyArray.count; i++)
    {
        SKSpriteNode *TempSprite=[self.nearbyArray objectAtIndex:i];
        [TempSprite setPosition:CGPointMake(TempSprite.position.x,TempSprite.position.y+moveSpeed)];
    }
    
    //循环滚动算法
    SKSpriteNode *RollOneSprite=[self.nearbyArray objectAtIndex:0];
    SKSpriteNode *RollTwoSprite=[self.nearbyArray objectAtIndex:1];
    SKSpriteNode *ThreeBackSprit=[self.nearbyArray objectAtIndex:2];
    
    if (RollOneSprite.position.y>(self.frame.size.height/2+self.frame.size.height))
    {
        RollOneSprite.position=CGPointMake(RollOneSprite.position.x, -(self.frame.size.height/2+self.frame.size.height-30));
        
    }
    if (RollTwoSprite.position.y>(self.frame.size.height/2+self.frame.size.height)) {
        RollTwoSprite.position=CGPointMake(RollOneSprite.position.x, -(self.frame.size.height/2+self.frame.size.height-30));
        
    }
    if (ThreeBackSprit.position.y>(self.frame.size.height/2+self.frame.size.height)) {
        ThreeBackSprit.position=CGPointMake(RollOneSprite.position.x, -(self.frame.size.height/2+self.frame.size.height-30));
        
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    //
    [self BackMove:5];
    
    GameViewController *vc = (GameViewController *) self.view.window.rootViewController;
    self.labelNumber.text = [NSString stringWithFormat:@"时间：%d s",vc.iNumber];
    
    float shipWTemp = self.ship.frame.size.width/2.;
    float shipHTemp = self.ship.frame.size.height/2.;
    
    if (fabs(vc.yawValue)<=30)
    {
        if (self.ship.position.x+vc.yawValue>=shipWTemp && self.ship.position.x+vc.yawValue < self.frame.size.width-shipWTemp)
        {
            self.ship.position = CGPointMake(self.ship.position.x+vc.yawValue, self.ship.position.y);
        }
    }
    
    if (fabs(vc.pitchValue)<=17)
    {
        if (self.ship.position.y-vc.pitchValue>=shipHTemp && self.ship.position.y-vc.pitchValue < self.frame.size.height-shipHTemp
            )
        {
            self.ship.position = CGPointMake(self.ship.position.x, self.ship.position.y-vc.pitchValue);
        }
    }
    
}
@end
