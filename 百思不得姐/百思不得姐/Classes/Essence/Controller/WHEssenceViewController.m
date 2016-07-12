//
//  WHEssenceViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHEssenceViewController.h"

@interface WHEssenceViewController ()

@end

@implementation WHEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHColorCommonBg;
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" hightImag:@"MainTagSubIconClick" action:@selector(onActionTagClick) addTarget:self];
}
- (void)onActionTagClick
{
    WHLogFunc
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = WHRandomColor;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
