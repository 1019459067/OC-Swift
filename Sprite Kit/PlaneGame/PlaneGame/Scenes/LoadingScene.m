//
//  LoadingScene.m
//  PlaneGame
//
//  Created by 肖伟华 on 2016/12/9.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "LoadingScene.h"
#import "SharedAtlas.h"
#import "HomeScene.h"

@interface LoadingScene ()
@property (assign, nonatomic) BOOL contentCreated;
@end

@implementation LoadingScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.contentCreated = YES;
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.backgroundColor = [SKColor lightGrayColor];
        [self createSceneContents];
    }
}

- (void)createSceneContents
{
    SKSpriteNode *nodeLoading = [SKSpriteNode spriteNodeWithTexture:[SharedAtlas textureLoadingWith:1]];
    nodeLoading.position = CGPointMake(self.size.width/2., self.size.height/2.);
    nodeLoading.zPosition = 0;
    nodeLoading.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:nodeLoading.size];
    nodeLoading.physicsBody.dynamic = NO;
    [self addChild:nodeLoading];

    [self createLabelVerion];

    SKAction *actionSequence = [SKAction sequence:@[[SharedAtlas actionLoading],
                                                    [SKAction waitForDuration:.2],
                                                    [SKAction removeFromParent]]];
    [nodeLoading runAction:actionSequence completion:^{
        HomeScene *scene = [[HomeScene alloc]initWithSize:self.size];
        SKTransition *tran = [SKTransition doorsOpenVerticalWithDuration:1.];
        [self.view pushScene:scene transition:tran];
    }];
}
- (void)createLabelVerion
{
    SKLabelNode *nodeVersion = [[SKLabelNode alloc]init];
    nodeVersion.text = [NSString stringWithFormat:@"v %@",[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    nodeVersion.fontColor = [SKColor blackColor];
    nodeVersion.fontSize = 11;
    nodeVersion.position = CGPointMake(self.size.width/2 , 10);
    [self addChild:nodeVersion];

}
@end
