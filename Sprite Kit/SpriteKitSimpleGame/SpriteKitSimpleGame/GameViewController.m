//
//  GameViewController.m
//  SpriteKitSimpleGame
//
//  Created by STMBP on 2016/12/3.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameViewController.h"
//#import "GameScene.h"
#import "HelloScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
//    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
//    
//    // Set the scale mode to scale to fit the window
//    scene.scaleMode = SKSceneScaleModeAspectFill;

    SKView *skView = (SKView *)self.view;
    
    // Present the scene
//    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    HelloScene *hello = [[HelloScene alloc]initWithSize:self.view.bounds.size];
    [skView presentScene:hello];
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
