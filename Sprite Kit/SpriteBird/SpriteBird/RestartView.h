//
//  RestartView.h
//  SpriteBird
//
//  Created by STMBP on 2017/3/14.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class RestartView;
@protocol RestartViewDelegate <NSObject>

- (void)restartView:(RestartView *)restartView didPressRestartButton:(SKSpriteNode *)node;

@end
@interface RestartView : SKSpriteNode
@property (assign, nonatomic) id <RestartViewDelegate>delegate;

+ (RestartView *)getInstanceWithSize:(CGSize)size;
- (void)disMiss;
- (void)showInScene:(SKScene *)scene;
@end
