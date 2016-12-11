//
//  PlayerPlane.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/11.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "PlayerPlane.h"
#import "SharedAtlas.h"
#import "GameScene.h"

@implementation PlayerPlane

+ (PlayerPlane *)createPlayerPlane
{
    PlayerPlane *player = [PlayerPlane spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypePlayerPlane1]];
    player.zPosition = 1;
    player.ph = 3;
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.categoryBitMask = PGRoleCategoryPlayerPlane;
    player.physicsBody.contactTestBitMask = PGRoleCategoryFoePlane;
    player.physicsBody.collisionBitMask = 0;

    return player;
}
@end
