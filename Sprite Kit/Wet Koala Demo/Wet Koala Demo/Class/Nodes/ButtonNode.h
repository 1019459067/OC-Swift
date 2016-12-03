//
//  ButtonNode.h
//  Wet Koala Demo
//
//  Created by STMBP on 2016/12/2.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void (^AnonBlock)();

@interface ButtonNode : SKSpriteNode

- (instancetype)initWithDefaultTexture:(SKTexture *)defaultTexture andTouchedTexture:(SKTexture *)touchedTexture;
- (void)setMethod:(void (^)())returnMethod;
+ (void)doButtonsActionBegan:(SKNode *)node touches:(NSSet *)touches withEvent:(UIEvent *)event;
+ (void)doButtonsActionEnded:(SKNode *)node touches:(NSSet *)touches withEvent:(UIEvent *)event;

@end
