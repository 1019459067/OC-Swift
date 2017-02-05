//
//  AGLKVertexAttribArrayBuffer.h
//  OpenGL_ES_03
//
//  Created by 肖伟华 on 2017/2/5.
//  Copyright © 2017年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;
@interface AGLKVertexAttribArrayBuffer : NSObject
@property(nonatomic,assign)GLuint glName;
@property(nonatomic,assign)GLsizeiptr bufferSizeBytes;
@property(nonatomic,assign)GLsizeiptr stride;

- (instancetype)initWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizeiptr)count data:(const GLvoid *)dataPtr usage:(GLenum)usage;
- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLuint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable;
- (void)drawArrayWithMode:(GLenum)model startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;
@end
