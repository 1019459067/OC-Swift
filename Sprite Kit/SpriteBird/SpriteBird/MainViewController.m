//
//  MainViewController.m
//  SpriteBird
//
//  Created by STMBP on 2017/3/13.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "MainViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "MainScene.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView *skView = [[SKView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:skView];
    skView.showsFPS = YES;
    skView.showsDrawCount = YES;
    skView.showsNodeCount = YES;

    MainScene *mainScene = [[MainScene alloc]initWithSize:skView.frame.size];
    [skView presentScene:mainScene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
