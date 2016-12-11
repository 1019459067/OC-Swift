//
//  GameViewController.h
//  PlaneGame
//
//  Created by STMBP on 2016/12/7.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

enum cv_live_detection_type{
    LIVE_NONE = 0,
    LIVE_YAW ,
    LIVE_BLINK ,    // 2
    LIVE_SMILE ,    // 3
    LIVE_PITCH ,
    LIVE_DETECTION_TYPE_COUNT
};

@interface GameViewController : UIViewController
@property (assign, nonatomic) int iNumber;
@property (assign, nonatomic) double yawValue;
@property (assign, nonatomic) double pitchValue;
- (void)startTime;
- (void)stopTime;

- (void)startCamera;
- (void)stopCamera;
@end
