//
//  GameViewController.h
//  Wet Koala Demo
//
//  Created by STMBP on 2016/12/2.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import <GameKit/GameKit.h>

@interface GameViewController : UIViewController

@property (nonatomic) BOOL gameCenterLogged;
@property (weak, nonatomic) GKLocalPlayer *gkLocalPlayer;

- (void)showGameCenterLeaderBoard;
- (void)switchSound;

- (void)reportScore:(int64_t)score;
- (void)shareText:(NSString *)string andImage:(UIImage *)image;

@end
