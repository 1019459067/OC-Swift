//
//  CounterHandler.h
//  Wet Koala Demo
//
//  Created by 肖伟华 on 2016/12/4.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CounterHandler : SKNode

-(CounterHandler *) initWithNumber:(NSInteger) initNumber;
-(void) setNumber:(NSInteger) number;
-(NSInteger) getNumber;

-(void) resetNumber;
-(void) increse;

@end
