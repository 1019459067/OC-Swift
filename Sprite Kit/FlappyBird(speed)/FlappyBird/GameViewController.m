//
//  GameViewController.m
//  FlappyBird
//
//  Created by STMBP on 2017/4/8.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "GameViewController.h"
#import "Scene.h"

@interface GameViewController ()
{
    Scene *scene;
}
@property (strong,nonatomic) SKView * gameView;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gameView = [[SKView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.gameView];

    self.gameView.showsFPS = YES;
    self.gameView.showsDrawCount = YES;
    self.gameView.showsNodeCount = YES;

    scene = [Scene sceneWithSize:self.gameView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
//    scene.delegateScene = self;

    [self.gameView presentScene:scene];
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
