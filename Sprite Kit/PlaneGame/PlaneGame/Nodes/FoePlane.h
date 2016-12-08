//
//  FoePlane.h
//  PlaneGame
//
//  Created by STMBP on 2016/12/8.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, PGFoePlaneType)
{
    PGFoePlaneTypeBig       = 1,
    PGFoePlaneTypeMedium,
    PGFoePlaneTypeSmall
};

@interface FoePlane : SKSpriteNode

/**
 生命值
 */
@property (assign, nonatomic) NSInteger ph;

/**
 敌人飞机类型
 */
@property (assign, nonatomic) PGFoePlaneType type;

+ (FoePlane *)createBigPlane;
+ (FoePlane *)createMediumPlane;
+ (FoePlane *)createSmallPlane;

@end
