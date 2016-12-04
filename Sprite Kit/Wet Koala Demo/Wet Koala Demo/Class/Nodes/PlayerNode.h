//
//  PlayerNode.h
//  Wet Koala Demo
//
//  Created by 肖伟华 on 2016/12/4.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerNode : SKSpriteNode

@property (nonatomic) BOOL isLive;

- (id)initWithDefaultTexture:(SKTexture *)defaultTexture andAnimateTextures:(NSArray *)animateTextures;
- (CGPoint)position;
- (void)ended;
- (void)update:(CFTimeInterval)currentTime;
- (void)setPhysicsBodyCategoryMask:(uint32_t) playerCategory andContactMask:(uint32_t) targetCategory;
- (void)setEndedTexture:(SKTexture *) endedTexture;
- (void)setEndedAdditionalTexture:(SKTexture *) endedAdditionalTexture;

@end
