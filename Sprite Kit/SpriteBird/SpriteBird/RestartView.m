//
//  RestartView.m
//  SpriteBird
//
//  Created by STMBP on 2017/3/14.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "RestartView.h"

@interface RestartView ()
@property (strong, nonatomic) SKSpriteNode *nodeButton;
@property (strong, nonatomic) SKLabelNode *nodeLabel;
@end
@implementation RestartView
- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    if (self = [super initWithColor:color size:size])
    {
        self.userInteractionEnabled = YES;
        
        self.nodeButton = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:17/255. green:39/255. blue:57/255. alpha:1] size:CGSizeMake(100, 60)];
        self.nodeButton.position = CGPointMake(size.width/2., size.height/2.);
        self.nodeButton.name = @"button";
        [self addChild:self.nodeButton];

        self.nodeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.nodeLabel.text = @"RESTART";
        self.nodeLabel.fontSize = 20.0f;
        self.nodeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        self.nodeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.nodeLabel.position = CGPointMake(0, 0);
        self.nodeLabel.fontColor = [UIColor whiteColor];
        [self.nodeButton addChild:self.nodeLabel];
    }
    return self;
}
+ (RestartView *)getInstanceWithSize:(CGSize)size
{
    RestartView *viewRestart = [RestartView spriteNodeWithColor:[UIColor colorWithWhite:1 alpha:0.6] size:size];
    viewRestart.anchorPoint = CGPointMake(0, 0);
    return viewRestart;
}
- (void)disMiss
{
    [self runAction:[SKAction fadeOutWithDuration:0.3] completion:^{
        [self removeFromParent];
    }];
}
- (void)showInScene:(SKScene *)scene
{
    self.alpha = 0;
    [scene addChild:self];
    [self runAction:[SKAction fadeInWithDuration:0.3]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint pointTouch = [[touches anyObject] locationInNode:self];
    SKNode *touchNode = [self nodeAtPoint:pointTouch];

    if (touchNode == self.nodeButton || touchNode == self.nodeLabel)
    {
        if ([self.delegate respondsToSelector:@selector(restartView:didPressRestartButton:)])
        {
            [self.delegate restartView:self didPressRestartButton:self.nodeButton];
        }
    }
}
@end
