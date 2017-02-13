//
//  AGLKContext.h
//  OpenGL_ES_03
//
//  Created by 肖伟华 on 2017/2/5.
//  Copyright © 2017年 XWH. All rights reserved.
//
#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext

@property(assign,nonatomic,readwrite)GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor;
@end
