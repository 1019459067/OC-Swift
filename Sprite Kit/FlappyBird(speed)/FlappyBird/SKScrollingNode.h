//
//  SKScrollingNode.h
//  FlappyBird
//
//  Created by STMBP on 2017/4/8.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKScrollingNode : SKSpriteNode
@property (assign,nonatomic) CGFloat scrollingSpeed;

+ (instancetype)scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float)width;
- (void)update:(NSTimeInterval)currentTime;
@end
