//
//  WHLoginRegisterViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/16.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHLoginRegisterViewController.h"

@interface WHLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginLeft;

@end

@implementation WHLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)onActionRegister:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.marginLeft.constant)
    {
        [sender setTitle:@"注册账号" forState:UIControlStateNormal];
        self.marginLeft.constant = 0;
    }else
    {
        [sender setTitle:@"已有账号?" forState:UIControlStateNormal];
        self.marginLeft.constant = - self.view.wh_width;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
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
    [self.view endEditing:YES];
}
@end
