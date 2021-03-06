//
//  GuideNode.m
//  Wet Koala Demo
//
//  Created by 肖伟华 on 2016/12/4.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GuideNode.h"

@interface GuideNode ()
{
    SKSpriteNode * _title;
    SKSpriteNode * _indicator;
    BOOL _didGuide;
    AnonBlock _returnMethod;
}
@end
@implementation GuideNode
-(id) initWithTitleTexture:(SKTexture *)titleTexture andIndicatorTexture:(SKTexture *)indicatorTexture {
    self = [super init];
    if(self){
        _didGuide = NO;
        _returnMethod = ^{};
        
        _title = [SKSpriteNode spriteNodeWithTexture:titleTexture];
        _indicator = [SKSpriteNode spriteNodeWithTexture:indicatorTexture];
        
        _title.position = CGPointMake(0.0, 80.0);
        _indicator.position = CGPointMake(0.0, -120.0);
        
        [self addChild:_title];
        [self addChild:_indicator];
        
        [_indicator runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction moveToX:-100 duration:1.0],[SKAction moveToX:100 duration:1.0]]]]];
    }
    return self;
}

-(void) setMethod:(void (^)()) returnMethod {
    _returnMethod = returnMethod;
}

-(void) runMethod {
    _returnMethod();
}

-(void) didGuide {
    _didGuide = YES;
    
    SKAction * actionMove = [SKAction fadeOutWithDuration:0.3];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    [_title runAction:[SKAction sequence:@[actionMove, actionMoveDone]] withKey:@"did-guide"];
    [_indicator runAction:[SKAction sequence:@[actionMove, actionMoveDone]] withKey:@"did-guide"];
    
    [self runMethod];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_didGuide){
        [self didGuide];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
@end
