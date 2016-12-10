//
//  ButtonNode.m
//  Wet Koala Demo
//
//  Created by STMBP on 2016/12/2.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "ButtonNode.h"

@interface ButtonNode ()

@property (strong, nonatomic) SKTexture *defaultTexture;
@property (strong, nonatomic) SKTexture *touchedTexture;
@property (strong, nonatomic) SKSpriteNode *button;
@property (strong, nonatomic) AnonBlock returnMethod;

@end
@implementation ButtonNode

- (instancetype)initWithDefaultTexture:(SKTexture *)defaultTexture andTouchedTexture:(SKTexture *)touchedTexture
{
    if (self = [super initWithTexture:defaultTexture])
    {
        self.returnMethod = ^{};

        self.defaultTexture = defaultTexture;
        self.touchedTexture = touchedTexture;

        self.button = [SKSpriteNode spriteNodeWithTexture:self.defaultTexture];
        SKAction *animations = [SKAction animateWithTextures:@[self.defaultTexture]
                                                timePerFrame:2.0f
                                                      resize:YES
                                                     restore:YES];
        [self.button runAction:[SKAction repeatActionForever:animations] withKey:@"button-default"];

        [self addChild:self.button];

        self.size = self.button.size;
    }
    return self;
}
- (void)setMethod:(void(^)())returnMethod
{
    self.returnMethod = returnMethod;
}

+ (void)doButtonsActionBegan:(SKNode *)node touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![ButtonNode isButtonPressed:[node children]])
    {
        CGPoint location = [[touches anyObject] locationInNode:node];
        SKNode *targetNode = [node nodeAtPoint:location];

        if ([node isEqual:targetNode.parent])
        {
            [targetNode touchesBegan:touches withEvent:event];
        }else
        {
            [targetNode.parent touchesBegan:touches withEvent:event];
        }
    }
}
+ (void)doButtonsActionEnded:(SKNode *)node touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInNode:node];
    SKNode *targetNode = [node nodeAtPoint:location];

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
    [self.button removeActionForKey:@"button-touched"];
}

+ (void)removeButtonPressed:(NSArray *)nodes
{
    for (SKNode * node in nodes) {
        if ([node isKindOfClass:[self class]])
        {
            ButtonNode *button = (ButtonNode *) node;
            [button didActionDefault];
        }
    }
}
+ (BOOL)isButtonPressed:(NSArray *)nodes
{
    BOOL pressed = NO;
    for (SKNode *node in nodes)
    {
        if ([node isKindOfClass:[self class]])
        {
            ButtonNode * button = (ButtonNode *)node;
            if ([button actionForKey:@"button-touched"])
            {
                pressed = YES;
            }
        }
    }
    return pressed;
}

- (void)didActionTouched
{
    if ([self.button actionForKey:@"button-touched"])
    {
        [self.button removeActionForKey:@"button-touched"];
    }
    SKAction *animations = [SKAction animateWithTextures:@[self.touchedTexture]
                                            timePerFrame:2.0f
                                                  resize:YES
                                                 restore:YES];
    [self.button runAction:[SKAction repeatActionForever:animations] withKey:@"button-touched"];

}

- (SKAction *)actionForKey:(NSString *)key
{
    return [self.button actionForKey:key];
}

- (void)removeActionForKey:(NSString *)key
{
    [self.button removeActionForKey:key];
}

- (void)runMethod
{
    self.returnMethod();
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self didActionTouched];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self actionForKey:@"button-touched"])
    {
        [self runMethod];
    }
    [self didActionDefault];
}
@end
