//
//  HomeScene.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/10.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "HomeScene.h"
#import "SharedAtlas.h"
#import "ButtonNode.h"
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
    ButtonNode *nodeStart = [[ButtonNode alloc]initWithDefaultTexture:[SKTexture textureWithImageNamed:@"button_start_normal"] andTouchedTexture:[SKTexture textureWithImageNamed:@"button_start_highlight"]];
    nodeStart.position = CGPointMake(self.size.width/2., self.size.height/2.);
    [nodeStart setMethod:^{
        [self startGame];
    }];
    [self addChild:nodeStart];

    ButtonNode *nodeSound = [[ButtonNode alloc]initWithDefaultTexture:[SKTexture textureWithImageNamed:@"button_soundon_normal"] andTouchedTexture:[SKTexture textureWithImageNamed:@"button_soundoff_highlight"]];
    nodeSound.position = CGPointMake(self.size.width/2., self.size.height/2.-70);
    [nodeSound setMethod:^{
        [self soundOff];
    }];
    [self addChild:nodeSound];
}
- (void)soundOff
{
    [DefaultValue shared].strSound = [NSString stringWithFormat:@"%d",![[DefaultValue shared].strSound intValue]];
}
- (void)startGame
{
    GameScene *scene = [[GameScene alloc]initWithSize:self.size];
    SKTransition *tran = [SKTransition doorsOpenVerticalWithDuration:1.];
    [self.view pushScene:scene transition:tran];

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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [ButtonNode doButtonsActionBegan:self touches:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [ButtonNode doButtonsActionEnded:self touches:touches withEvent:event];
}
@end
