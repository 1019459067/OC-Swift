//
//  GameViewController.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/7.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "LaunchView.h"

@interface GameViewController ()
@property (strong, nonatomic) LaunchView *launchingView;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.launchingView = [[LaunchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.launchingView];

    [self performSelectorInBackground:@selector(loadResources) withObject:nil];

}
- (void)loadResources
{
    [NSThread sleepForTimeInterval:2.0f];
    [self.launchingView removeFromSuperview];

        // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];

        // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;

    SKView *skView = (SKView *)self.view;

        // Present the scene
    [skView presentScene:scene];

    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

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
