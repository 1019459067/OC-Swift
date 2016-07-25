//
//  WHRefreshHeader.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/25.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHRefreshHeader.h"

@implementation WHRefreshHeader

- (void)prepare
{
    [super prepare];
    self.automaticallyChangeAlpha = YES;
    self.lastUpdatedTimeLabel.textColor = [UIColor orangeColor];
    self.stateLabel.textColor = [UIColor orangeColor];
}
@end
