//
//  ButtonNode.m
//  Wet Koala Demo
//
//  Created by STMBP on 2016/12/2.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "ButtonNode.h"

@interface ButtonNode ()
{
    SKTexture * _defaultTexture;
    SKTexture * _touchedTexture;
    SKSpriteNode * _button;
    AnonBlock _returnMethod;
}
@end
@implementation ButtonNode

- (instancetype)initWithDefaultTexture:(SKTexture *)defaultTexture andTouchedTexture:(SKTexture *)touchedTexture
{
    if (self = [super initWithTexture:defaultTexture])
    {
        _returnMethod = ^{};

        _defaultTexture = defaultTexture;
        _touchedTexture = touchedTexture;

        _button = [SKSpriteNode spriteNodeWithTexture:_defaultTexture];
        [_button runAction:
         [SKAction repeatActionForever:
          [SKAction animateWithTextures:@[_defaultTexture]
                           timePerFrame:10.0f
                                 resize:YES
                                restore:YES]] withKey:@"button-default"];

        [self addChild:_button];

        self.size = _button.size;
    }
    return self;
}
- (void)setMethod:(void (^)())returnMethod
{
    _returnMethod = returnMethod;
}

+ (void)doButtonsActionBegan:(SKNode *)node touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![ButtonNode isButtonPressed:[node children]])
    {
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInNode:node];
        SKNode * targetNode = [node nodeAtPoint:location];

        if ([node isEqual:targetNode.parent]) {
            [targetNode touchesBegan:touches withEvent:event];
        }else{
            [targetNode.parent touchesBegan:touches withEvent:event];
        }
    }
}
+ (void)doButtonsActionEnded:(SKNode *)node touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:node];
    SKNode * targetNode = [node nodeAtPoint:location];

    if ([node isEqual:targetNode.parent])
    {
        [targetNode touchesEnded:touches withEvent:event];
    }else
    {
        [targetNode.parent touchesEnded:touches withEvent:event];
    }
    [ButtonNode removeButtonPressed:[node children]];
}


- (void)didActionDefault
{
    [_button removeActionForKey:@"button-touched"];
}
+ (void)removeButtonPressed:(NSArray *)nodes
{
    for (SKNode * node in nodes) {
        if ([node isKindOfClass:[self class]])
        {
            ButtonNode * button = (ButtonNode *) node;
            [button didActionDefault];
        }
    }
}
+ (BOOL)isButtonPressed:(NSArray *)nodes
{
    BOOL pressed = NO;
    for (SKNode * node in nodes)
    {
        if ([node isKindOfClass:[self class]])
        {
            ButtonNode * button = (ButtonNode *) node;
            if ([button actionForKey:@"button-touched"])
            {
                pressed = YES;
            }
        }
    }
    return pressed;
}
@end
