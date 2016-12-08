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
            return [[SharedAtlas shared]textureNamed:@"enemy3_fly_1"];
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
@end
