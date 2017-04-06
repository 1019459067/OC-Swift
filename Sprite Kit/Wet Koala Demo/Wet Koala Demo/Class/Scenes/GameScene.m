//
//  GameScene.m
//  Wet Koala Demo
//
//  Created by STMBP on 2016/12/2.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameScene.h"
#import "PlayerNode.h"
#import "GuideNode.h"
#import "CounterHandler.h"
#import "ButtonNode.h"
#import "HomeScene.h"
#import "GameViewController.h"
#import "SSKeychain.h"

static const uint32_t rainCategory     =  0x1 << 0;
static const uint32_t koalaCategory    =  0x1 << 1;

@interface GameScene ()<SKPhysicsContactDelegate>
{
    int _rainCount;//雨滴个数
    BOOL _bRaindrop;//是否下雨
}
@property BOOL contentCreated;
@property (nonatomic) SKTextureAtlas *atlas;
@property (weak, nonatomic) SKSpriteNode *ground;
@property (weak, nonatomic) PlayerNode *player;
@property (weak, nonatomic) CounterHandler *counter;
@property (weak, nonatomic) GuideNode *guide;
@property (weak, nonatomic) SKSpriteNode *score;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSArray *waterDroppingFrames;

@property (assign, nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (assign, nonatomic) NSTimeInterval lastSpawnTimeInterval;
@end

@implementation GameScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        self.contentCreated = YES;
        [self createSceneContents];
        [[self view] addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)]];
    }
}
- (void)createSceneContents
{
    _bRaindrop = NO;
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    self.atlas = [SKTextureAtlas atlasNamed:@"sprite"];
    
    //set background
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    //set cloud
    SKSpriteNode *cloudDark = [SKSpriteNode spriteNodeWithImageNamed:@"cloud-dark"];
    cloudDark.anchorPoint = CGPointMake(0.5, 1.0);
    cloudDark.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:cloudDark];

    SKSpriteNode *cloudBright =  [SKSpriteNode spriteNodeWithImageNamed:@"cloud-bright"];
    cloudBright.anchorPoint = CGPointMake(0.5, 1.0);
    cloudBright.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:cloudBright];
    
    
    SKAction *cloudMoveLeftRight = [SKAction repeatActionForever:[SKAction sequence:@[
                                                                                      [SKAction moveByX:30.0 y:0.0 duration:3.0],
                                                                                      [SKAction moveByX:-30.0 y:0.0 duration:3.0]]]];
    
    SKAction *cloudMoveUpDown = [SKAction repeatActionForever:[SKAction sequence:@[
                                                                                   [SKAction moveByX:0.0 y:30.0 duration:2.5],
                                                                                   [SKAction moveByX:0.0 y:-30.0 duration:2.5]]]];

    [cloudDark   runAction:cloudMoveLeftRight];
    [cloudBright runAction:cloudMoveUpDown];
    
    // set ground
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    ground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) - ground.size.height/4);
    ground.anchorPoint = CGPointMake(0.5, 0.0);
    [self addChild:ground];
    self.ground = ground;
    
    // add Koala Player
    NSMutableArray * koalaAnimateTextures = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 6; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"koala-walk-%d", i];
        SKTexture * texture = [self.atlas textureNamed:textureName];
        [koalaAnimateTextures addObject:texture];
    }
    SKTexture *koalaTexture = [self.atlas textureNamed:@"koala-stop"];
    PlayerNode *player = [[PlayerNode alloc] initWithDefaultTexture:koalaTexture andAnimateTextures:koalaAnimateTextures];
    
    [player setEndedTexture:[self.atlas textureNamed:@"koala-wet"]];
    [player setEndedAdditionalTexture:[self.atlas textureNamed:@"wet"]];
    
    player.position = CGPointMake(CGRectGetMidX(self.frame), ground.position.y + ground.size.height + koalaTexture.size.height/2 - 15.0);
    [player setPhysicsBodyCategoryMask:koalaCategory andContactMask:rainCategory];
    [self addChild:player];
    self.player = player;
    
    // add Rain Sprite
    NSMutableArray *rainTextures = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 4; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"rain-%d",i];
        SKTexture *texture = [self.atlas textureNamed:textureName];
        [rainTextures addObject:texture];
    }
    self.waterDroppingFrames = [[NSArray alloc] initWithArray:rainTextures];

    // add Guide
    GuideNode *guide = [[GuideNode alloc] initWithTitleTexture:[self.atlas textureNamed:@"text-swipe"]
                                            andIndicatorTexture:[self.atlas textureNamed:@"finger"]];
    guide.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [guide setMethod:^{
        [self gameStart];
    }];
    [self addChild:guide];
    self.guide = guide;
}
- (void)gameStart
{
    _rainCount = 0;
    //add count
    SKSpriteNode *score = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"score"]];
    score.position = CGPointMake(CGRectGetMidX(self.frame),  self.ground.position.y + self.ground.size.height * 3 / 4 - 27.0);
    score.alpha = 0.0;
    [self addChild:score];
    self.score = score;
    
    //
    CounterHandler *counter = [[CounterHandler alloc] init];
    counter.position = CGPointMake(CGRectGetMidX(self.frame) + 105.0, _ground.position.y + _ground.size.height * 3 / 4 - 45.0);
    counter.alpha = 0.0;
    [self addChild:counter];
    self.counter = counter;
    
    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:0.5],
                                         [SKAction runBlock:^{
        
        [score runAction:[SKAction fadeInWithDuration:0.3]];
        [counter runAction:[SKAction fadeInWithDuration:0.3]];
    }],
                                         [SKAction waitForDuration:0.5],
                                         [SKAction runBlock:^{
        _bRaindrop = YES;
    }]]]];
    [self setGameStartTime];
}
- (void)setGameStartTime
{
    self.startTime = [NSDate date];
}
#pragma mark - responder
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [ButtonNode doButtonsActionEnded:self touches:touches withEvent:event];
    [self.player touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.player touchesMoved:touches withEvent:event];
    [self.guide touchesMoved:touches withEvent:event];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [ButtonNode doButtonsActionBegan:self touches:touches withEvent:event];
    [self.player touchesBegan:touches withEvent:event];
}
#pragma mark - SKPhysicsContactDelegate
//有了物理作用作出相应反应
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & rainCategory) != 0 &&
        (secondBody.categoryBitMask & koalaCategory) != 0)
    {
        [self player:(SKSpriteNode *) secondBody.node didCollideWithRaindrop:(SKSpriteNode *)firstBody.node];
    }
}
- (void)player:(SKSpriteNode *)playerNode didCollideWithRaindrop:(SKSpriteNode *)raindropNode
{
    if (self.player.isLive)
    {
        
        [self.player ended];
        [self stopAllRaindrop];
        
        [raindropNode runAction:[SKAction fadeOutWithDuration:0.3]];
        
        [self.counter runAction:[SKAction fadeOutWithDuration:0.3]];
        [self.score runAction:[SKAction fadeOutWithDuration:0.3]];
        
        [self runAction:[SKAction sequence:@[
                                             [SKAction waitForDuration:1.0],
                                             [SKAction runBlock:^{// call gameover screen
            [self gameOver];
         }]]]];
        
    }
}
- (void)gameOver
{
    SKSpriteNode *gameOverText = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"text-gameover"]];
    gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * 3 / 2);
    
    SKSpriteNode *scoreBoard = [SKSpriteNode spriteNodeWithTexture:[self.atlas textureNamed:@"scoreboard"]];
    scoreBoard.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    SKSpriteNode *newRecord = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(0.0, 0.0)];
    
    if([self storeHighScore:(int) [_counter getNumber]])
    {
        NSArray * recordAnimate = @[[self.atlas textureNamed:@"text-new-record-pink"],
                                    [self.atlas textureNamed:@"text-new-record-red"]];
        newRecord = [SKSpriteNode spriteNodeWithTexture: recordAnimate[0]];
        newRecord.position = CGPointMake(self.frame.size.width / 2 + 90, self.frame.size.height / 2 + 45 );
        newRecord.zPosition = 100.0;
        [newRecord runAction:[SKAction repeatActionForever:
                              [SKAction animateWithTextures:recordAnimate
                                               timePerFrame:0.2f
                                                     resize:YES
                                                    restore:YES]] withKey:@"newrecord"];
        
        [newRecord runAction:[SKAction repeatActionForever:
                              [SKAction sequence:@[[SKAction scaleBy:1.2 duration:0.1],
                                                   [SKAction scaleBy:10.0/12.0 duration:0.1]
                                                   ]]]];
        
        newRecord.alpha = 0.0;
    }
    
    CounterHandler *currentScore = [[CounterHandler alloc] initWithNumber:[_counter getNumber]];
    currentScore.position = CGPointMake(CGRectGetMidX(self.frame) + 105, CGRectGetMidY(self.frame) - 4.0);
    
    CounterHandler *highScore = [[CounterHandler alloc] initWithNumber:[self getHighScore]];
    highScore.position = CGPointMake(CGRectGetMidX(self.frame) + 105, CGRectGetMidY(self.frame) - 55.0);
    
    CGFloat buttonY = CGRectGetMidY(self.frame) / 2;
    
    SKTexture *homeDefault = [self.atlas textureNamed:@"button-home-off"];
    SKTexture *homeTouched = [self.atlas textureNamed:@"button-home-on"];
    
    ButtonNode *homeButton = [[ButtonNode alloc] initWithDefaultTexture:homeDefault andTouchedTexture:homeTouched];
    homeButton.position = CGPointMake(CGRectGetMidX(self.frame) - (homeButton.size.width / 2 + 8), buttonY);
    
    [homeButton setMethod: ^ (void) {
        SKTransition *reveal = [SKTransition fadeWithDuration: 0.5];
        SKScene *homeScene = [[HomeScene alloc] initWithSize:self.size];
        [self.view presentScene:homeScene transition:reveal];
    }];
    
    
    SKTexture *shareDefault = [self.atlas textureNamed:@"button-share-off"];
    SKTexture *shareTouched = [self.atlas textureNamed:@"button-share-on"];
    
    ButtonNode *shareButton = [[ButtonNode alloc] initWithDefaultTexture:shareDefault andTouchedTexture:shareTouched];
    shareButton.position = CGPointMake(CGRectGetMidX(self.frame) + (shareButton.size.width / 2 + 8), buttonY);
    
    // prepare share action
    UIImage *pointboard = [UIImage imageNamed:@"pointboard.jpg"];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentRight];
    
    UIFont *font = [UIFont fontWithName:@"Molot" size:40.0];
    
    NSShadow *fontBackgroundShadow = [[NSShadow alloc] init];
    fontBackgroundShadow.shadowBlurRadius = 0.0;
    fontBackgroundShadow.shadowColor = [UIColor colorWithRed:98.0/256.0
                                                       green:93.0/256.0
                                                        blue:89.0/256.0
                                                       alpha:1.0];
    fontBackgroundShadow.shadowOffset = CGSizeMake(0.0, 5.0);
    
    NSDictionary *fontBackgroundAtts = @{  NSFontAttributeName : font,
                                           NSParagraphStyleAttributeName : style,
                                           NSStrokeColorAttributeName : [UIColor whiteColor],
                                           NSStrokeWidthAttributeName : @-20.0f,
                                           NSShadowAttributeName : fontBackgroundShadow
                                           };
    
    NSDictionary *fontAtts = @{ NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : [UIColor colorWithRed:86.0/256.0
                                                                                  green:86.0/256.0
                                                                                   blue:86.0/256.0
                                                                                  alpha:1.0],
                                 NSParagraphStyleAttributeName : style
                                 };
    
    CGRect usernameRect = CGRectMake(0.0, 185.0, 820.0, 80.0);
    CGRect scoreRect = CGRectMake(600.0, 262.0, 220.0, 80.0);
    
    [shareButton setMethod: ^ (void) {
        
        GameViewController *vc = (GameViewController *)self.view.window.rootViewController;
        
        NSString * sharetext = [NSString stringWithFormat:@"I just scored %d in #KoalaHatesRain!", (int) [_counter getNumber]];
        
        UIGraphicsBeginImageContext(pointboard.size);
        
        [pointboard drawInRect:CGRectMake(0,0,pointboard.size.width, pointboard.size.height)];
        
        GKPlayer * localPlayer = vc.gkLocalPlayer;
        NSString * username = localPlayer.alias;
        
        [username drawInRect:CGRectIntegral(usernameRect) withAttributes: fontBackgroundAtts];
        [username drawInRect:CGRectIntegral(usernameRect) withAttributes: fontAtts];
        
        NSString * score = [NSString stringWithFormat:@"%d", (int)[_counter getNumber]];
        [score drawInRect:CGRectIntegral(scoreRect) withAttributes: fontBackgroundAtts];
        [score drawInRect:CGRectIntegral(scoreRect) withAttributes: fontAtts];
        
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [vc shareText:sharetext andImage:image];
    } ];
    
    
    CGFloat smallButtonY = buttonY - homeButton.size.height;
    
    SKTexture * rateDefault = [_atlas textureNamed:@"button-rate-off"];
    SKTexture * rateTouched = [_atlas textureNamed:@"button-rate-on"];
    
    ButtonNode * rateButton = [[ButtonNode alloc] initWithDefaultTexture:rateDefault andTouchedTexture:rateTouched];
    rateButton.position = CGPointMake(CGRectGetMidX(self.frame) + rateButton.size.width / 2 + 8, smallButtonY);
    
    [rateButton setMethod: ^ (void) {
        
    }];
    
    SKTexture * retryDefault = [_atlas textureNamed:@"button-retry-off"];
    SKTexture * retryTouched = [_atlas textureNamed:@"button-retry-on"];
    
    ButtonNode * retryButton = [[ButtonNode alloc] initWithDefaultTexture:retryDefault andTouchedTexture:retryTouched];
    retryButton.position = CGPointMake(CGRectGetMidX(self.frame) - retryButton.size.width / 2 - 8, smallButtonY);
    
    [retryButton setMethod: ^ (void) {
        SKTransition * reveal = [SKTransition fadeWithColor:[UIColor whiteColor] duration:0.5];
        SKScene * gameScene = [[GameScene alloc] initWithSize:self.size];
        [self.view presentScene:gameScene transition:reveal];
    } ];
    
    [self addChild:gameOverText];
    [self addChild:scoreBoard];
    
    SKAction * buttonMove = [SKAction sequence:@[
                                                 [SKAction moveToY:buttonY - 10.0 duration:0.0],
                                                 [SKAction group:@[[SKAction fadeInWithDuration:0.3], [SKAction moveToY:buttonY duration:0.5]]
                                                  ]]];
    
    SKAction * smallButtonMove = [SKAction sequence:@[
                                                      [SKAction waitForDuration:0.3],
                                                      [SKAction moveToY:buttonY - homeButton.size.height - 10.0 duration:0.0],
                                                      [SKAction group:@[[SKAction fadeInWithDuration:0.3], [SKAction moveToY:buttonY - homeButton.size.height duration:0.5]]
                                                       ]]];
    
    gameOverText.alpha = 0.0;
    scoreBoard.alpha = 0.0;
    
    [self runAction:[SKAction sequence:@[[SKAction runBlock:^{
        [gameOverText runAction:
         [SKAction sequence:@[
                              [SKAction group:@[[SKAction scaleBy:2.0 duration:0.0]]],
                              [SKAction group:@[[SKAction fadeInWithDuration:0.5],[SKAction scaleBy:0.5 duration:0.2]]]
                              ]]];
    }],
                                         [SKAction waitForDuration:0.2],
                                         [SKAction runBlock:^{
        [scoreBoard runAction:[SKAction fadeInWithDuration:0.5]];
    }],
                                         [SKAction waitForDuration:0.6],
                                         [SKAction runBlock:^{
        
        [self addChild:highScore];
        [self addChild:currentScore];
        [self addChild:newRecord];
        [newRecord runAction:[SKAction fadeInWithDuration:0.3]];
    }],
                                         [SKAction waitForDuration:0.3],
                                         [SKAction runBlock:^{
        homeButton.alpha = 0.0;
        shareButton.alpha = 0.0;
        [self addChild:homeButton];
        [self addChild:shareButton];
        
        rateButton.alpha = 0.0;
        retryButton.alpha = 0.0;
        [self addChild:rateButton];
        [self addChild:retryButton];
        
        [homeButton runAction:buttonMove];
        [shareButton runAction:buttonMove];
        
        [rateButton runAction:smallButtonMove];
        [retryButton runAction:smallButtonMove];
    }]]]];
}
- (int)getHighScore
{
    int highRecord = 0;
    if ([SSKeychain passwordForService:@"koala" account:@"koala"] != nil)
    {
        highRecord = [[SSKeychain passwordForService:@"koala" account:@"koala"] intValue];
    }
    return (int) highRecord;
}
- (BOOL)storeHighScore:(int) score
{
    int highRecord = 0;
    
    if ([SSKeychain passwordForService:@"koala" account:@"koala"] != nil)
    {
        highRecord = [[SSKeychain passwordForService:@"koala" account:@"koala"] intValue];
    }
    
    if (highRecord < score)
    {
        [SSKeychain setPassword:[NSString stringWithFormat:@"%d",score] forService:@"koala" account:@"koala"];
                GameViewController *vc = (GameViewController *) self.view.window.rootViewController;
        if (vc.gameCenterLogged)
        {
            [vc reportScore:(int64_t)score];
        }
        
        return true;
    }
    return false;
}
- (void)stopAllRaindrop
{
    for (SKSpriteNode * node in [self children])
    {
        if ([node actionForKey:@"rain"])
        {
            [node removeActionForKey:@"rain"];
        }
    }
}

///Called before each frame is rendered
- (void)update:(NSTimeInterval)currentTime
{
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1.0) {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    [self.player update:currentTime];

}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    if(self.player.isLive && _bRaindrop)
    {
        self.lastSpawnTimeInterval += timeSinceLast;
        if(self.lastSpawnTimeInterval > [self getFireTime])
        {
            self.lastSpawnTimeInterval = 0;
            [self addRaindrop];
        }
    }
}
-(void)addRaindrop
{
    SKTexture *temp = self.waterDroppingFrames[0];
    SKSpriteNode * raindrop = [SKSpriteNode spriteNodeWithTexture:temp];
    int minX = raindrop.size.width / 2;
    int maxX = self.frame.size.width - raindrop.size.width / 2;
    
    CGFloat s = - ceil(self.startTime.timeIntervalSinceNow);
    if ((s < 20 && _rainCount % 4 == 0) ||
        (s >= 20 && _rainCount % 4 == 0)) {
        int x = [self.player position].x + self.frame.size.width / 2;
        minX = x - 10.0;
        maxX = x + 10.0;
    }
    
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    if (actualX > self.frame.size.width - raindrop.size.width / 2)
    {
        actualX = self.frame.size.width - raindrop.size.width / 2;
    }else if (actualX < raindrop.size.width / 2) {
        actualX = raindrop.size.width / 2;
    }
    
    raindrop.name = @"raindrop";
    
    // add raindrop physicsbody
    raindrop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:raindrop.size];
    raindrop.physicsBody.dynamic = YES;
    raindrop.physicsBody.categoryBitMask = rainCategory;
    raindrop.physicsBody.contactTestBitMask = koalaCategory;
    raindrop.physicsBody.collisionBitMask = 0;
    raindrop.physicsBody.usesPreciseCollisionDetection = YES;
    
    raindrop.position = CGPointMake(actualX, self.frame.size.height + raindrop.size.height / 2);
    
    [raindrop runAction:[SKAction repeatActionForever:
                         [SKAction animateWithTextures:self.waterDroppingFrames
                                          timePerFrame:0.1f
                                                resize:YES
                                               restore:YES]] withKey:@"rainingWaterDrop"];
    
    [self addChild:raindrop];
    
    int minDuration = 10;
    int maxDuration = 20;
    
    if(s >= 40 && _rainCount % 8 == 0)
    {
        minDuration = 20;
        maxDuration = 30;
    }else if(s >= 20 && _rainCount % 6 == 0)
    {
        minDuration = 20;
        maxDuration = 25;
    }
    
    int rangeDuration = maxDuration - minDuration;
    float actualDuration = ((arc4random() % rangeDuration) + minDuration) / 10;
    
    SKAction *actionMove = [SKAction moveTo:CGPointMake(actualX, self.ground.position.y + self.ground.size.height)
                                    duration:actualDuration];
    SKAction *countMove = [SKAction runBlock:^{
        [self.counter increse];
    }];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [raindrop runAction:[SKAction sequence:@[actionMove, countMove, actionMoveDone]] withKey:@"rain"];
    _rainCount++;
}

- (CGFloat)getFireTime
{
    CGFloat s = - ceil(self.startTime.timeIntervalSinceNow);
    CGFloat fireTime = 1.0;
    if (s < 15)
    {
        fireTime = (25 - s) * 0.02;
    }else {
        fireTime = 0.2;
    }
    return fireTime;
}

@end
