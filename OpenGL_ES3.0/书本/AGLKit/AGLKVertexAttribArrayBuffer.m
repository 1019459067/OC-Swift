//
//  AGLKVertexAttribArrayBuffer.m
//  OpenGL_ES_03
//
//  Created by 肖伟华 on 2017/2/5.
//  Copyright © 2017年 XWH. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@implementation AGLKVertexAttribArrayBuffer

- (instancetype)initWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizeiptr)count data:(const GLvoid *)dataPtr usage:(GLenum)usage
{
    NSParameterAssert(0 < stride);
    NSAssert((0 < count && NULL != dataPtr)||(0 == count && NULL == dataPtr),@"data must not be NULL or count >0");
    
    if (self = [super init])
    {
        self.stride = stride;
        self.bufferSizeBytes = stride * count;
        
        glGenBuffers(1, &_name);// 生成
        glBindBuffer(GL_ARRAY_BUFFER, self.name);//绑定
        glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, dataPtr, usage);//缓存数据
        
        NSAssert(0 != self.name, @"Failed to generate name");
    }
    return self;
}

- (void)reinitWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizeiptr)count data:(const GLvoid *)dataPtr
{
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != self.name, @"Invalid name");

    self.stride = stride;
    self.bufferSizeBytes = stride * count;

    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, dataPtr, GL_STATIC_DRAW);
}


- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLuint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable
{
    NSParameterAssert((0 < count)&& (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != self.name, @"Invalid name");
//    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    if (shouldEnable)
    {
        glEnableVertexAttribArray(index);//启用
    }

    /**
     @param index 每个顶点的位置信息
     @param count 每个位置有几个部分
     */
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, (GLsizei)self.stride, NULL+offset);//设置指针
#ifdef DEBUG
    GLenum error = glGetError();
    if(GL_NO_ERROR != error)
    {
        NSLog(@"GL Error: 0x%x", error);
    }
#endif
}

- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count
{
    NSAssert(self.bufferSizeBytes >= (first + count) * self.stride, @"Attemp to draw more vertex data than available.");
    glDrawArrays(mode, first, count);//绘图
}

+ (void)drawPreparedArraysWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;
{
    glDrawArrays(mode, first, count);
}
- (void)dealloc
{
    if (self.name != 0)
    {
        glDeleteBuffers(1, &_name);//删除
        self.name = 0;
    }
}
@end
