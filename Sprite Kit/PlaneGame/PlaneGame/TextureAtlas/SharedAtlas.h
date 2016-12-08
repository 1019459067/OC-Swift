//
//  SharedAltes.h
//  PlaneGame
//
//  Created by STMBP on 2016/12/8.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, PGTextureType)
{
    PGTextureTypeBackground     = 1,
    PGTextureTypeBullet1,
    PGTextureTypeBullet2,
    PGTextureTypePlayerPlane1,
    PGTextureTypePlayerPlane2,
    PGTextureTypeSmallFoePlane,
    PGTextureTypeMediumFoePlane,
    PGTextureTypeBigFoePlane
};

@interface SharedAtlas : SKTextureAtlas

+ (instancetype)shared;


/**
 根据类型来获取对应的纹理

 @param type 参数类型
 @return SKTexture,纹理类型
 */
+ (SKTexture *)textureWithType:(PGTextureType)type;


/**
 玩家的动作

 @return SKAction,动作
 */
+ (SKAction *)playerPlaneAction;
@end
