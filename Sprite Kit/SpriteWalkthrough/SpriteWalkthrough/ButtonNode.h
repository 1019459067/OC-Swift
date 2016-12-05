//
//  ButtonNode.h
//  SpriteWalkthrough
//
//  Created by STMBP on 2016/12/5.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ButtonNode : SKLabelNode

- (void)didClickedMethod:(void(^)())completion;

@end
