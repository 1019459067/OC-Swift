//
//  HomeScene.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/10.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "HomeScene.h"
#import "SharedAtlas.h"
#import "PGButton.h"
#import "GameScene.h"
#import "GameViewController.h"

@interface HomeScene ()
@property (assign, nonatomic) BOOL contentCreated;
@end

@implementation HomeScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.contentCreated = YES;
        self.scaleMode = SKSceneScaleModeAspectFit;
        [self initBackground];
        [self initTitle];
        [self initButton];
    }
}
- (void)initTitle
{
    SKLabelNode *nodeLabel = [SKLabelNode labelNodeWithFontNamed:MarkerFelt_Thin];
    nodeLabel.text = @"Plane Wars";
    nodeLabel.fontColor = [SKColor blackColor];
    nodeLabel.fontSize = 75;
    nodeLabel.position = CGPointMake(self.size.width/2 , self.size.height*3/4.);
    [self addChild:nodeLabel];
}
- (void)initButton
{
    UIView *viewPause = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    viewPause.center = self.view.center;
    [self.view addSubview:viewPause];

    PGButton *buttonStart = [[PGButton alloc]initWithCenter:CGPointMake(viewPause.frame.size.width/2., viewPause.frame.size.height/2.) bound:CGRectMake(0,0,200,40) title:@"start" selectedTitle:nil];
    [buttonStart didClicked:^{
        [self startGame:buttonStart];
    }];
    [viewPause addSubview:buttonStart];

    PGButton *buttonSound = [[PGButton alloc]initWithCenter:CGPointMake(viewPause.frame.size.width/2., viewPause.frame.size.height/2.+70) bound:CGRectMake(0,0,200,40) title:@"sound on" selectedTitle:@"sound off"];
    [buttonSound didClicked:^{
        [self soundOff:buttonSound];
    }];
    [viewPause addSubview:buttonSound];
}
- (void)soundOff:(PGButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {

    }
}
- (void)startGame:(PGButton *)sender
{
    [sender.superview removeFromSuperview];

    GameScene *scene = [[GameScene alloc]initWithSize:self.size];
    SKTransition *tran = [SKTransition doorsOpenVerticalWithDuration:1.];
    [self.view presentScene:scene transition:tran];

    GameViewController *vc = (GameViewController *) self.view.window.rootViewController;
    [vc startCamera];
}
- (void)initBackground
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypeBackground] size:self.size];
    background.position = CGPointMake(self.size.width/2., 0);
    background.anchorPoint = CGPointMake(0.5, 0);
    background.zPosition = 0;
    [self addChild:background];
}

@end
