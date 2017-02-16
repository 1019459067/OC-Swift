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

/**
 顶点属性数组缓存
 */
@interface AGLKVertexAttribArrayBuffer : NSObject

/** 缓存标示符 */
@property(nonatomic,assign)GLuint name;

/** 需要复制的缓存的字节数量 */
@property(nonatomic,assign)GLsizeiptr bufferSizeBytes;

/** 步幅 */
@property(nonatomic,assign)GLsizeiptr stride;

/**
 初始化顶点属性数组缓存

 @param stride 步幅
 @param count 顶点个数
 @param dataPtr 字节地址
 @param usage 缓存数据用法
 @return AGLKVertexAttribArrayBuffer
 */
- (instancetype)initWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizeiptr)count data:(const GLvoid *)dataPtr usage:(GLenum)usage;

/**
 重新初始化顶点属性数组缓存,作用在于定期地用变化了顶点位置重新初始化顶点数组缓存的内容来产生一个意在突出纹理失真的简单动画

 @param stride 步幅
 @param count 顶点个数
 @param dataPtr 顶点数据
 */
- (void)reinitWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizeiptr)count data:(const GLvoid *)dataPtr;

/**
 准备渲染工作

 @param index 当前绑定包含每个顶点的位置信息
 @param count 每个位置有几部分
 @param offset 开始位置访问的偏移量
 @param shouldEnable 是否启动顶点缓存渲染操作
 */
- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLuint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable;

/**
 绘图工作

 @param mode 渲染缓存处理类型
 @param first 需要渲染的第一个顶点位置
 @param count 需要渲染的顶点数量
 */
- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;
+ (void)drawPreparedArraysWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;

@end
