//
//  GameViewController.m
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/3.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameViewController.h"
#import "HelloScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;

    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;

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
