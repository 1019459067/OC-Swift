//
//  Scene.h
//  FlappyBird
//
//  Created by STMBP on 2017/4/8.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define BACK_SCROLLING_SPEED 14.5
#define FLOOR_SCROLLING_SPEED BACK_SCROLLING_SPEED

    // Obstacles
#define OBSTACLE_INTERVAL_SPACE 180
#define OBSTACLE_MIN_HEIGHT 60
#define VERTICAL_GAP_SIZE 120
#define FIRST_OBSTACLE_PADDING 100



    // Views
///////////////////////////////////////////
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)


@protocol SceneDelegate <NSObject>
- (void) eventStart;
- (void) eventPlay;
- (void) eventWasted;
@end

@interface Scene : SKScene
@property (assign) id<SceneDelegate> delegateScene;
@end
