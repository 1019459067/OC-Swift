//
//  PlayerPlane.h
//  PlaneGame
//
//  Created by STMBP on 2016/12/11.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerPlane : SKSpriteNode

/**
 生命值
 */
@property (assign, nonatomic) NSInteger ph;

+ (PlayerPlane *)createPlayerPlane;

@end
