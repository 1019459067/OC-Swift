//
//  SharedAltes.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/8.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "SharedAtlas.h"

@implementation SharedAtlas

+ (instancetype)shared
{
    static SharedAtlas *atlas;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        atlas = [SharedAtlas atlasNamed:@"gameArts-hd"];
    });
    return atlas;
}

+ (SKTexture *)textureWithType:(PGTextureType)type
{
    switch (type)
    {
        case PGTextureTypeBackground:
            return [[SharedAtlas shared]textureNamed:@"background_2"];
            break;
        case PGTextureTypeBullet1:
            return [[SharedAtlas shared]textureNamed:@"bullet1"];
            break;
        case PGTextureTypeBullet2:
            return [[SharedAtlas shared]textureNamed:@"bullet2"];
            break;
        case PGTextureTypePlayerPlane1:
            return [[SharedAtlas shared]textureNamed:@"hero_fly_1"];
            break;
        case PGTextureTypePlayerPlane2:
            return [[SharedAtlas shared]textureNamed:@"hero_fly_2"];
            break;
        case PGTextureTypeSmallFoePlane:
            return [[SharedAtlas shared]textureNamed:@"enemy1_fly_1"];
            break;
        case PGTextureTypeMediumFoePlane:
            return [[SharedAtlas shared]textureNamed:@"enemy3_fly_1"];
            break;
        case PGTextureTypeBigFoePlane:
            return [[SharedAtlas shared]textureNamed:@"enemy2_fly_1"];
            break;
        default:
            break;
    }
}

#pragma mark - init
+ (SKTexture *)texturePlayerPlaneWith:(int)index
{
    return [[SharedAtlas shared]textureNamed:[NSString stringWithFormat:@"hero_fly_%d",index]];
}
+ (SKTexture *)textureBlownUpPlayerPlaneWithIndex:(int)index
{
    return [[SharedAtlas shared] textureNamed:[NSString stringWithFormat:@"hero_blowup_%d.png",index]];
}
+ (SKTexture *)textureHittedFoePlaneWithType:(int)type animationIndex:(int)index
{
    return [[SharedAtlas shared]textureNamed:[NSString stringWithFormat:@"enemy%d_hit_%d",type,index]];
}
+ (SKTexture *)textureBlownUpFoePlaneWithType:(int)type animationIndex:(int)index
{
    return [[SharedAtlas shared]textureNamed:[NSString stringWithFormat:@"enemy%d_blowup_%d",type,index]];
}
#pragma mark - action
+ (SKAction *)playerPlaneAction
{
    NSMutableArray *arrayTextures = [NSMutableArray array];
    for (int i = 0; i < 2; i++)
    {
        SKTexture *texture = [self texturePlayerPlaneWith:i+1];
        [arrayTextures addObject:texture];
    }
    return [SKAction repeatActionForever:[SKAction animateWithTextures:arrayTextures timePerFrame:0.1]];
}
+ (SKAction *)actionBlowupWithPlayerPlane
{
    NSMutableArray *arrayTextures = [NSMutableArray array];
    for (int i = 0 ; i < 4; i++)
    {
        SKTexture *texture = [self textureBlownUpPlayerPlaneWithIndex:i+1];
        [arrayTextures addObject:texture];
    }
    return [SKAction sequence:@[[SKAction animateWithTextures:arrayTextures timePerFrame:0.15],[SKAction removeFromParent]]];
}

+ (SKAction *)actionHittedWithFoePlaneType:(PGFoePlaneType)type
{
    switch (type)
    {
        case PGFoePlaneTypeBig:
        {
            NSMutableArray *arrayTextures = [NSMutableArray array];
            SKTexture *texture1 = [self textureHittedFoePlaneWithType:2 animationIndex:1];
            SKAction *action1 = [SKAction setTexture:texture1];
            [arrayTextures addObject:action1];

            SKTexture *texture2 = [self textureWithType:PGTextureTypeBigFoePlane];
            SKAction *action2 = [SKAction setTexture:texture2];
            [arrayTextures addObject:action2];

            return [SKAction sequence:arrayTextures];
        }
            break;
        case PGFoePlaneTypeMedium:
        {
            NSMutableArray *arrayTextures = [NSMutableArray array];
            for (int i = 0 ; i < 2; i++)
            {
                SKTexture *texture = [self textureHittedFoePlaneWithType:3 animationIndex:i+1];
                [arrayTextures addObject:[SKAction setTexture:texture]];
            }
            return [SKAction sequence:arrayTextures];
        }
            break;
        case PGFoePlaneTypeSmall:
            break;
        default:
            break;
    }
    return nil;
}

+ (SKAction *)actionBlowupWithFoePlaneType:(PGFoePlaneType)type
{
    switch (type)
    {
        case PGFoePlaneTypeBig:
        {
            NSMutableArray *arrayTextures = [NSMutableArray array];
            for (int i = 0 ; i < 7; i++)
            {
                SKTexture *texture = [self textureBlownUpFoePlaneWithType:2 animationIndex:i+1];
                [arrayTextures addObject:texture];
            }
            return [SKAction sequence:@[[SKAction animateWithTextures:arrayTextures timePerFrame:0.2],[SKAction removeFromParent]]];
        }
            break;
        case PGFoePlaneTypeMedium:
        {
            NSMutableArray *arrayTextures = [NSMutableArray array];
            for (int i = 0 ; i < 4; i++)
            {
                SKTexture *texture = [self textureBlownUpFoePlaneWithType:3 animationIndex:i+1];
                [arrayTextures addObject:texture];
            }
            return [SKAction sequence:@[[SKAction animateWithTextures:arrayTextures timePerFrame:0.1],[SKAction removeFromParent]]];
        }
            break;
        case PGFoePlaneTypeSmall:
        {
            NSMutableArray *arrayTextures = [NSMutableArray array];
            for (int i = 0 ; i < 4; i++)
            {
                SKTexture *texture = [self textureBlownUpFoePlaneWithType:1 animationIndex:i+1];
                [arrayTextures addObject:texture];
            }
            return [SKAction sequence:@[[SKAction animateWithTextures:arrayTextures timePerFrame:0.05],[SKAction removeFromParent]]];
        }
            break;
        default:
            break;
    }
    return nil;

}
@end
