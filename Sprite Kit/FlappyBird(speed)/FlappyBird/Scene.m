//
//  Scene.m
//  FlappyBird
//
//  Created by STMBP on 2017/4/8.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "Scene.h"
#import "SKScrollingNode.h"
#import "BirdNode.h"
#import "Constants.h"
#import "Score.h"

@interface Scene ()<SKPhysicsContactDelegate>
{
    SKScrollingNode * back;
    BirdNode * bird;
    SKLabelNode * scoreLabel;

    int nbObstacles;
    NSMutableArray * topPipes;
    NSMutableArray * bottomPipes;
}
@end
@implementation Scene
static bool wasted = NO;

- (void)didMoveToView:(SKView *)view
{
    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = edgeCategory;
    [self startGame];
//    [self test];
}
- (void)test
{
    SKSpriteNode *node = [[SKSpriteNode alloc]initWithColor:[UIColor orangeColor] size:CGSizeMake(40, 40)];
    node.anchorPoint = CGPointZero;
    [self addChild:node];
    
    float maxVariance = self.frame.size.height - (2*OBSTACLE_MIN_HEIGHT) - VERTICAL_GAP_SIZE;
    float variance = randf(0, maxVariance);
    node.position = CGPointMake(10, variance);
    NSLog(@"variance: %f",variance);
}
- (void)startGame
{
    wasted = NO;
    [self removeAllChildren];

    [self createBackground];
    [self createObstacles];
    
    [self createScore];
    [self createBird];
}
- (void) createScore
{
    self.score = 0;
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 500;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 100);
    scoreLabel.alpha = 0.2;
    [self addChild:scoreLabel];
}

- (void)createBird
{
    bird = [BirdNode new];
    [bird setPosition:CGPointMake(100, CGRectGetMidY(self.frame))];
    [bird setName:@"bird"];
    [self addChild:bird];
}

- (void)createObstacles
{
        // Calculate how many obstacles we need, the less the better
    nbObstacles = ceil((self.frame.size.width)/(OBSTACLE_INTERVAL_SPACE));

    CGFloat lastBlockPos = 0;
    bottomPipes = @[].mutableCopy;
    topPipes = @[].mutableCopy;
    for(int i=0;i<nbObstacles;i++)
    {
        SKSpriteNode *topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe_top"];
        [topPipe setAnchorPoint:CGPointZero];
        [self addChild:topPipe];
        [topPipes addObject:topPipe];

        SKSpriteNode *bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe_bottom"];
        [bottomPipe setAnchorPoint:CGPointZero];
        [self addChild:bottomPipe];
        [bottomPipes addObject:bottomPipe];

            // Give some time to the player before first obstacle
        if(0 == i)
        {
            [self place:bottomPipe and:topPipe atX:self.frame.size.width+FIRST_OBSTACLE_PADDING];
        }
        else
        {
            [self place:bottomPipe and:topPipe atX:lastBlockPos + bottomPipe.frame.size.width +OBSTACLE_INTERVAL_SPACE];
        }
        lastBlockPos = bottomPipe.position.x;
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(wasted)
    {
        [self startGame];
    }else
    {
        if (!bird.physicsBody)
        {
            [bird startPlaying];
            if([self.delegate respondsToSelector:@selector(eventPlay)]){
//                [self.delegate eventPlay];
            }
        }
        [bird bounce];
    }
    
    
}
#pragma mark - Creations

- (void)createBackground
{
    back = [SKScrollingNode scrollingNodeWithImageNamed:@"back" inContainerSize:self.frame.size];
    [back setScrollingSpeed:BACK_SCROLLING_SPEED];
    [back setAnchorPoint:CGPointZero];
    [back setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    [self addChild:back];
    
    [back setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    back.physicsBody.categoryBitMask = backBitMask;
    back.physicsBody.contactTestBitMask = birdBitMask;
}

- (void)update:(NSTimeInterval)currentTime
{
    if(wasted){
        return;
    }
        // ScrollingNodes
//    if(bird.physicsBody)
    {
        [back update:currentTime];
    }

        // Other
    [bird update:currentTime];
    [self updateObstacles:currentTime];
    [self updateScore:currentTime];
}
- (void)updateScore:(NSTimeInterval) currentTime
{
    for(int i=0;i<nbObstacles;i++)
    {
        SKSpriteNode * topPipe = (SKSpriteNode *) topPipes[i];
        
        // Score, adapt font size
        if(X(topPipe) + WIDTH(topPipe)/2 > bird.position.x &&
           X(topPipe) + WIDTH(topPipe)/2 < bird.position.x + FLOOR_SCROLLING_SPEED){
            self.score +=1;
            scoreLabel.text = [NSString stringWithFormat:@"%lu",self.score];
            if(self.score>=10){
                scoreLabel.fontSize = 340;
                scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 120);
            }
        }
    }
}

- (void)updateObstacles:(NSTimeInterval)currentTime
{
    if(!bird.physicsBody)
    {
        return;
    }
    
    for(int i=0;i<nbObstacles;i++)
    {
            // Get pipes bby pairs
        SKSpriteNode * topPipe = (SKSpriteNode *) topPipes[i];
        SKSpriteNode * bottomPipe = (SKSpriteNode *) bottomPipes[i];

            // Check if pair has exited screen, and place them upfront again
        if (topPipe.frame.origin.x< -WIDTH(topPipe))
        {
            SKSpriteNode * mostRightPipe = (SKSpriteNode *) topPipes[(i+(nbObstacles-1))%nbObstacles];
            [self place:bottomPipe and:topPipe atX:mostRightPipe.frame.origin.x+WIDTH(topPipe)+OBSTACLE_INTERVAL_SPACE];
        }

            // Move according to the scrolling speed
        topPipe.position = CGPointMake(topPipe.frame.origin.x - FLOOR_SCROLLING_SPEED,topPipe.frame.origin.y);
        bottomPipe.position = CGPointMake(bottomPipe.frame.origin.x - FLOOR_SCROLLING_SPEED,bottomPipe.frame.origin.y);
    }
}

static inline CGFloat randf(CGFloat low,CGFloat high);
- (void)place:(SKSpriteNode *)bottomPipe and:(SKSpriteNode *)topPipe atX:(float)xPos
{
        // Maths
    float variance = randf(OBSTACLE_MIN_HEIGHT*1.5 ,
                           bottomPipe.size.height+OBSTACLE_MIN_HEIGHT*1.5-VERTICAL_GAP_SIZE
                           );

        // Bottom pipe placement
    bottomPipe.position = CGPointMake(xPos,-variance);

        // Top pipe placement
    topPipe.position = CGPointMake(xPos,self.frame.size.height+OBSTACLE_MIN_HEIGHT-variance);

    
    bottomPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, WIDTH(bottomPipe) , HEIGHT(bottomPipe))];
    bottomPipe.physicsBody.categoryBitMask = blockBitMask;
    bottomPipe.physicsBody.contactTestBitMask = birdBitMask;
    
    topPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, WIDTH(topPipe), HEIGHT(topPipe))];
    topPipe.physicsBody.categoryBitMask = blockBitMask;
    topPipe.physicsBody.contactTestBitMask = birdBitMask;

}
#pragma mark - Physic

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if(wasted){ return; }
    static int i = 0;
    NSLog(@"didBeginContact %d",i++);

    wasted = true;
    [Score registerScore:self.score];

}
//生成0-1 之前的两位小数
static inline CGFloat randf(CGFloat low,CGFloat high)
{
    return skRandf()*(high-low)+low;
}
static inline CGFloat skRandf()
{
    return (arc4random() % 100+1)/100.;
}


@end
