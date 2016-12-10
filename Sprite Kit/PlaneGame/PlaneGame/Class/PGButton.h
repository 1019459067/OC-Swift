//
//  PGButton.h
//  PlaneGame
//
//  Created by STMBP on 2016/12/10.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGButton : UIButton

- (instancetype)initWithCenter:(CGPoint)center bound:(CGRect)bounds title:(NSString *)title selectedTitle:(NSString *)titleSelected;

- (void)didClicked:(void(^)())completion;

@end
