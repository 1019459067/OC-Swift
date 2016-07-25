//
//  WHRefreshFooter.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/25.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHRefreshFooter.h"

@implementation WHRefreshFooter

- (void)prepare
{
    [super prepare];
    self.stateLabel.textColor = [UIColor orangeColor];
    self.triggerAutomaticallyRefreshPercent = 0;
    self.automaticallyRefresh = NO;
}
@end
