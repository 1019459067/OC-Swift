//
//  GuideNode.h
//  Wet Koala Demo
//
//  Created by 肖伟华 on 2016/12/4.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void (^AnonBlock)();

@interface GuideNode : SKSpriteNode

-(id) initWithTitleTexture:(SKTexture *)titleTexture andIndicatorTexture:(SKTexture *)indicatorTexture;
-(void) setMethod:(void (^)()) returnMethod;
-(void) runMethod;

@end
