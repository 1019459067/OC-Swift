//
//  ViewController.m
//  Hello World
//
//  Created by STMBP on 16/9/30.
//  Copyright © 2016年 sensetime. All rights reserved.
//
//  http://blog.csdn.net/sx1989827/article/details/47304971


#import "ViewController.h"
//#import <OpenGLES/ES3/gl.h>
//#import <OpenGLES/ES3/glext.h>

@interface ViewController ()
{
    EAGLContext *_context;// 渲染层,用于渲染结果在目标surface上的更新。
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if (!_context) {
        NSLog(@"failed to init eaglcontext");
    }
    
    GLKView *view = (GLKView*)self.view;
    view.context = _context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:_context];
    glEnable(GL_DEPTH_TEST);//开启深度测试，就是让离你近的物体可以遮挡离你远的物体。
    glClearColor(0.2, 0.2, 0.2, 1);
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    NSLog(@"%s",__func__);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);//清除surface内容，恢复至初始状态。  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
