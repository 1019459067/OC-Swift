//
//  WHFollowViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHFollowViewController.h"
#import "WHRecommendFollowViewController.h"
#import "WHLoginRegisterViewController.h"

@interface WHFollowViewController ()

@end

@implementation WHFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHColorCommonBg;
    self.navigationItem.title = @"我的关注";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" hightImag:@"friendsRecommentIcon-click" action:@selector(onActionFriendClick) addTarget:self];
    
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    tf.borderStyle = UITextBorderStyleLine;
//    tf.placeholderColor = [UIColor redColor];
    tf.placeholder = @"xxxxxx";
    [self.view addSubview:tf];
    
    NSLog(@"%@",tf.placeholderColor);

}
- (IBAction)onActionLogin:(UIButton *)sender
{
    WHLoginRegisterViewController *vc = [[WHLoginRegisterViewController alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)onActionFriendClick
{
    WHRecommendFollowViewController *vc = [[WHRecommendFollowViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
