//
//  GameViewController.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/7.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameViewController.h"
#import "LoadingScene.h"
#import "GameScene.h"
#import "PGButton.h"

@interface GameViewController ()
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;

//    GameScene *scene = [[GameScene alloc]initWithSize:self.view.bounds.size];
    LoadingScene *scene = [[LoadingScene alloc]initWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameOver) name:k_Noti_GameOver object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gamePause) name:k_Noti_Pause object:nil];

}
- (void)gamePause
{
    ((SKView *)self.view).paused = YES;

    UIView *viewPause = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    viewPause.center = self.view.center;
    [self.view addSubview:viewPause];

    PGButton *buttonContinue = [[PGButton alloc]initWithCenter:CGPointMake(viewPause.frame.size.width/2., viewPause.frame.size.height/2.-30) bound:CGRectMake(0,0,200,40) title:@"continue"];
    [buttonContinue didClicked:^{
        [self continueGame:buttonContinue];
    }];
    [viewPause addSubview:buttonContinue];

    PGButton *buttonRestart = [[PGButton alloc]initWithCenter:CGPointMake(viewPause.frame.size.width/2., viewPause.frame.size.height/2.+30) bound:CGRectMake(0,0,200,40) title:@"restart"];
    [buttonRestart didClicked:^{
        [self restart:buttonRestart];
    }];
    [viewPause addSubview:buttonRestart];
}
- (void)continueGame:(UIButton *)sender
{
    [sender.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
}
- (void)gameOver
{
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    viewBg.center = self.view.center;
    [self.view addSubview:viewBg];

    PGButton *button = [[PGButton alloc]initWithCenter:CGPointMake(viewBg.frame.size.width/2., viewBg.frame.size.height/2.) bound:CGRectMake(0,0,200,30) title:@"restart"];
    [button didClicked:^{
        [self restart:button];
    }];
    [viewBg addSubview:button];
}
- (void)restart:(UIButton *)sender
{
    [sender.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:k_Noti_Restart object:nil];
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
