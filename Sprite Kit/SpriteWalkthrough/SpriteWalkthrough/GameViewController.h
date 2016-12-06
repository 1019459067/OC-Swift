//
//  GameViewController.h
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/3.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameViewController : UIViewController

@property (assign, nonatomic) int iNumber;
@property (assign, nonatomic) double yawValue;
@property (assign, nonatomic) double pitchValue;
- (void)startTime;
- (void)stopTime;

- (void)startLocalCam;
- (void)stopLocalCam;
@end
