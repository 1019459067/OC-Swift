//
//  GameViewController.m
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/3.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameViewController.h"
#import "HomeScene.h"

@interface GameViewController()

@property (strong, nonatomic) NSTimer *timer;

@end
@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;

    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;

    HomeScene *scene = [[HomeScene alloc]initWithSize:self.view.bounds.size];
    [skView presentScene:scene];

//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addNumber) userInfo:nil repeats:YES];
//    [self.timer setFireDate:[NSDate distantFuture]];
}
- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addNumber) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}
- (void)addNumber
{
    self.iNumber = self.iNumber+1;
}
- (void)stopTime
{
    [self.timer invalidate];
    self.timer = nil;
    self.iNumber = 0;
}
- (void)startTime
{
    [self.timer setFireDate:[NSDate distantPast]];
}
- (int)iNumber
{
    return _iNumber;
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
