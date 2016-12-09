//
//  LoadingScene.m
//  PlaneGame
//
//  Created by 肖伟华 on 2016/12/9.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "LoadingScene.h"
#import "SharedAtlas.h"
#import "GameScene.h"

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
    
    SKAction *actionSequence = [SKAction sequence:@[[SharedAtlas actionLoading],
                                                    [SKAction waitForDuration:.2],
                                                    [SKAction removeFromParent]]];
    [nodeLoading runAction:actionSequence completion:^{
        GameScene *scene = [[GameScene alloc]initWithSize:self.size];
        SKTransition *tran = [SKTransition doorsOpenVerticalWithDuration:1.];
        [self.view presentScene:scene transition:tran];
    }];
}
@end
