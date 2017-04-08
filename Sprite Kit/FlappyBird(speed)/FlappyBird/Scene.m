//
//  Scene.m
//  FlappyBird
//
//  Created by STMBP on 2017/4/8.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "Scene.h"
#import "SKScrollingNode.h"
#import "Math.h"

@interface Scene ()
{
    SKScrollingNode * back;

    int nbObstacles;
    NSMutableArray * topPipes;
    NSMutableArray * bottomPipes;
}
@end
@implementation Scene
- (void)didMoveToView:(SKView *)view
{
    [self startGame];
}

static bool wasted = NO;
- (void)startGame
{
        // Reinit
    wasted = NO;

    [self removeAllChildren];

    [self createBackground];
//    [self createFloor];
//    [self createScore];
    [self createObstacles];
//    [self createBird];

        // Floor needs to be in front of tubes
//    floor.zPosition = bird.zPosition + 1;
//
//    if([self.delegate respondsToSelector:@selector(eventStart)]){
//        [self.delegate eventStart];
//    }
}
- (void) createObstacles
{
        // Calculate how many obstacles we need, the less the better
    nbObstacles = ceil((self.frame.size.width)/(OBSTACLE_INTERVAL_SPACE));

    CGFloat lastBlockPos = 0;
    bottomPipes = @[].mutableCopy;
    topPipes = @[].mutableCopy;
    for(int i=0;i<nbObstacles;i++){

        SKSpriteNode * topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe_top"];
        [topPipe setAnchorPoint:CGPointZero];
        [self addChild:topPipe];
        [topPipes addObject:topPipe];

        SKSpriteNode * bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe_bottom"];
        [bottomPipe setAnchorPoint:CGPointZero];
        [self addChild:bottomPipe];
        [bottomPipes addObject:bottomPipe];

            // Give some time to the player before first obstacle
        if(0 == i){
            [self place:bottomPipe and:topPipe atX:WIDTH(self)+FIRST_OBSTACLE_PADDING];
        }else{
            [self place:bottomPipe and:topPipe atX:lastBlockPos + WIDTH(bottomPipe) +OBSTACLE_INTERVAL_SPACE];
        }
        lastBlockPos = topPipe.position.x;
    }
    
}
#pragma mark - Creations

- (void)createBackground
{
    back = [SKScrollingNode scrollingNodeWithImageNamed:@"back" inContainerWidth:self.frame.size.width];
    [back setScrollingSpeed:BACK_SCROLLING_SPEED];
    [back setAnchorPoint:CGPointZero];
    [back setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
//    back.physicsBody.categoryBitMask = backBitMask;
//    back.physicsBody.contactTestBitMask = birdBitMask;
    [self addChild:back];
}

- (void)update:(NSTimeInterval)currentTime
{
    if(wasted){
        return;
    }

        // ScrollingNodes
    [back update:currentTime];

        // Other
//    [bird update:currentTime];
    [self updateObstacles:currentTime];
//    [self updateScore:currentTime];
}

- (void) updateObstacles:(NSTimeInterval)currentTime
{
//    if(!bird.physicsBody){
//        return;
//    }

    for(int i=0;i<nbObstacles;i++){

            // Get pipes bby pairs
        SKSpriteNode * topPipe = (SKSpriteNode *) topPipes[i];
        SKSpriteNode * bottomPipe = (SKSpriteNode *) bottomPipes[i];

            // Check if pair has exited screen, and place them upfront again
        if (topPipe.frame.origin.x< -WIDTH(topPipe)){
            SKSpriteNode * mostRightPipe = (SKSpriteNode *) topPipes[(i+(nbObstacles-1))%nbObstacles];
            [self place:bottomPipe and:topPipe atX:mostRightPipe.frame.origin.x+WIDTH(topPipe)+OBSTACLE_INTERVAL_SPACE];
        }

            // Move according to the scrolling speed
        topPipe.position = CGPointMake(topPipe.frame.origin.x - FLOOR_SCROLLING_SPEED,topPipe.frame.origin.y);
        bottomPipe.position = CGPointMake(bottomPipe.frame.origin.x - FLOOR_SCROLLING_SPEED,bottomPipe.frame.origin.y);
    }
}

- (void) place:(SKSpriteNode *) bottomPipe and:(SKSpriteNode *) topPipe atX:(float) xPos
{
        // Maths
    float availableSpace = self.frame.size.height;
    float maxVariance = availableSpace - (2*OBSTACLE_MIN_HEIGHT) - VERTICAL_GAP_SIZE;
    float variance = [Math randomFloatBetween:0 and:maxVariance];

        // Bottom pipe placement
    float minBottomPosY = OBSTACLE_MIN_HEIGHT - HEIGHT(self);
    float bottomPosY = minBottomPosY + variance;
    bottomPipe.position = CGPointMake(xPos,bottomPosY);
    bottomPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, WIDTH(bottomPipe) , HEIGHT(bottomPipe))];
//    bottomPipe.physicsBody.categoryBitMask = blockBitMask;
//    bottomPipe.physicsBody.contactTestBitMask = birdBitMask;

        // Top pipe placement
    topPipe.position = CGPointMake(xPos,bottomPosY + HEIGHT(bottomPipe) + VERTICAL_GAP_SIZE);
    topPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, WIDTH(topPipe), HEIGHT(topPipe))];

//    topPipe.physicsBody.categoryBitMask = blockBitMask;
//    topPipe.physicsBody.contactTestBitMask = birdBitMask;
}

@end
