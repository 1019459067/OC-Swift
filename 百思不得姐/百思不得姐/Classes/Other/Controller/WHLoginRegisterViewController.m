//
//  WHLoginRegisterViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/16.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHLoginRegisterViewController.h"

@interface WHLoginRegisterViewController ()

@end

@implementation WHLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)onActionRegister:(UIButton *)sender {
}
- (IBAction)onActionBack:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
