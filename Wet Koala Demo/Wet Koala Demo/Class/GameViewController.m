//
//  GameViewController.m
//  Wet Koala Demo
//
//  Created by STMBP on 2016/12/2.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "HomeScene.h"

#define k_Sound @"k_Sound" //设置声音
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameViewController ()<GKGameCenterControllerDelegate>

@property (nonatomic) GKLocalPlayer *gkLocalPlayer;
@property (nonatomic) BOOL gameCenterLogged;
@property (strong, nonatomic) NSUserDefaults *userDefault;
@property (nonatomic) AVAudioPlayer * audioPlayerBgMusic;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView *skView = (SKView*)self.view;
    if (!skView.scene)
    {
        [self authenticateLocalPlayer];

        self.userDefault = [NSUserDefaults standardUserDefaults];
        if (![self.userDefault objectForKey:k_Sound])
        {
            [self.userDefault setObject:@"YES" forKey:k_Sound];
        }

        NSString *strMusicSetting = [self.userDefault objectForKey:k_Sound];
        NSURL *urlBg = [[NSBundle mainBundle]URLForResource:@"bgm" withExtension:@"m4a"];
        self.audioPlayerBgMusic = [[AVAudioPlayer alloc]initWithContentsOfURL:urlBg error:nil];
        self.audioPlayerBgMusic.numberOfLoops = -1;
        [self.audioPlayerBgMusic prepareToPlay];

        if ([strMusicSetting isEqualToString:@"YES"])
        {
            [self.audioPlayerBgMusic play];
        }

        skView.showsFPS = NO;
        skView.showsNodeCount = NO;

        self.gameCenterLogged = NO;

        SKScene *scene = [HomeScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
}
- (void)authenticateLocalPlayer
{
    self.gkLocalPlayer = [GKLocalPlayer localPlayer];

    __weak GKLocalPlayer *weakPlayer = self.gkLocalPlayer;

    __weak typeof(self) weakSelf = self;
    self.gkLocalPlayer.authenticateHandler = ^(UIViewController *viewController,NSError *error){
        if (error)
        {
            NSLog(@"authenticateLocalPlayer error:%@",error);
        }

        if (viewController)
        {
            [weakSelf showAuthenticationDialogWhenReasonable];
        }else if (weakPlayer.authenticated)
        {
            [weakSelf authenticatedPlayer:weakPlayer];
        }else
        {
            [weakSelf disableGameCenter];
        }
    };
}

- (void)disableGameCenter
{
    self.gameCenterLogged = NO;
}
- (void)authenticatedPlayer:(GKLocalPlayer *)player
{
    self.gkLocalPlayer = player;
    self.gameCenterLogged = YES;
    [self loadLeaderboardInfo];
}
- (void)loadLeaderboardInfo
{
#warning _leaderboardIdentifier = leaderboardIdentifier;
    [self.gkLocalPlayer loadDefaultLeaderboardIdentifierWithCompletionHandler:nil];
}
- (void)showAuthenticationDialogWhenReasonable
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
}

- (void)showGameCenterLeaderBoard
{
    if(self.gameCenterLogged){
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
            [self presentViewController: gameCenterController animated: YES completion:nil];
        }
    }else{
        [self showAuthenticationDialogWhenReasonable];
    }
}
#pragma mark - GKGameCenterControllerDelegate
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchSound
{
    if ([self isSound])
    {
        [self turnOffSound];
    }else
    {
        [self turnOnSound];
    }
}
- (BOOL)isSound
{
    NSString * musicPlaySetting = [self.userDefault objectForKey:k_Sound];
    if ([musicPlaySetting isEqualToString:@"YES"])
    {
        return YES;
    }else{
        return NO;
    }
}
- (void)turnOffSound
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [self.audioPlayerBgMusic stop];
    [self.userDefault setObject:@"NO" forKey:@"sound"];
}

- (void)turnOnSound
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [self.audioPlayerBgMusic play];
    [self.userDefault setObject:@"YES" forKey:@"sound"];
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
