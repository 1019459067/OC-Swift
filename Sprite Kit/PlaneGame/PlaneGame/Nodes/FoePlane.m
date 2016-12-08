//
//  FoePlane.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/8.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "FoePlane.h"
#import "SharedAtlas.h"

@implementation FoePlane

+ (FoePlane *)createBigPlane
{
#warning 有两个图片
    FoePlane *foePlane = [FoePlane spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypeBigFoePlane]];
    foePlane.ph = 7;
    foePlane.type = PGFoePlaneTypeBig;
    foePlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foePlane.size];
    return foePlane;
}

+ (FoePlane *)createMediumPlane
{
    FoePlane *foePlane = [FoePlane spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypeMediumFoePlane]];
    foePlane.ph = 3;
    foePlane.type = PGFoePlaneTypeMedium;
    foePlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foePlane.size];
    return foePlane;
}

+ (FoePlane *)createSmallPlane
{
    FoePlane *foePlane = [FoePlane spriteNodeWithTexture:[SharedAtlas textureWithType:PGTextureTypeSmallFoePlane]];
    foePlane.ph = 1;
    foePlane.type = PGFoePlaneTypeSmall;
    foePlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foePlane.size];
    return foePlane;
}
@end
