//
//  GameViewController.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/7.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameViewController.h"
#import "LaunchView.h"
#import "GameScene.h"
@interface GameViewController ()
@property (strong, nonatomic) LaunchView *launchingView;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.launchingView = [[LaunchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.launchingView];

    [self performSelector:@selector(loadResources) withObject:nil afterDelay:2];
}
- (void)loadResources
{
    [self.launchingView removeFromSuperview];

    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    GameScene *scene = [[GameScene alloc]initWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];

}

- (BOOL)shouldAutorotate
{
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
