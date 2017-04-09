//
//  BirdNode.h
//  FlappyBird
//
//  Created by 肖伟华 on 2017/4/10.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BirdNode : SKSpriteNode

- (void) update:(NSUInteger) currentTime;
- (void) startPlaying;
- (void) bounce;

@end
