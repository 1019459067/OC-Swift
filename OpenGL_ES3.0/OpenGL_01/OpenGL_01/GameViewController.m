//
//  GameViewController.m
//  OpenGL_01
//
//  Created by STMBP on 2016/12/17.
//  Copyright © 2016年 1019459067. All rights reserved.
//
/*
 http://www.jianshu.com/p/750fde1d8b6a
 */

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>


@interface GameViewController ()
@property (strong, nonatomic) EAGLContext *context;

/**
 着色器
 */
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (assign, nonatomic) int mCount;
@end

@implementation GameViewController

    //顶点数据，前三个是顶点坐标，后面两个是纹理坐标
GLfloat squareVertexData[] =
{
    0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
    -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
    -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
};
/*
 顶点数组里包括顶点坐标，OpenGLES的世界坐标系是[-1, 1]，故而点(0, 0)是在屏幕的正中间。
 纹理坐标系的取值范围是[0, 1]，原点是在左下角。故而点(0, 0)在左下角，点(1, 1)在右上角。
 */
    //顶点索引
GLuint indices[] =
{
    0, 1, 2,
    1, 3, 0
};
/*
 索引数组是顶点数组的索引，把squareVertexData数组看成4个顶点，每个顶点会有5个GLfloat数据，索引从0开始。
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableColorFormatRGBA8888; //颜色缓冲区格式
    [EAGLContext setCurrentContext:self.context];

    [self addOpenGL];
}
- (void)addOpenGL
{
    self.mCount = sizeof(indices)/sizeof(GLint);

        // 顶点数据缓存
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);

    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

    /*
     glGenBuffers申请一个标识符
     glBindBuffer把标识符绑定到GL_ARRAY_BUFFER上
     glBufferData把顶点数据从cpu内存复制到gpu内存
     */

    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL+0);

    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);//纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL+3);
    /*
     glEnableVertexAttribArray 是开启对应的顶点属性
     glVertexAttribPointer设置合适的格式从buffer里面读取数据
     */
        //纹理贴图
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"20150716093225221" ofType:@"jpg"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//纹理坐标系是相反的
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];

    self.effect = [[GLKBaseEffect alloc]init];
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.name = textureInfo.name;
}

    ///渲染场景代码
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.3, 0.6, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

        // 启动着色器
    [self.effect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.mCount, GL_UNSIGNED_INT, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
