//
//  ViewController.m
//  OpenGL_ES_05
//
//  Created by STMBP on 2017/2/6.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKTextureLoader.h"

typedef struct
{
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static const SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},

    {{ 0.5f,  0.5f, 0.0f}, {1.0f, 1.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

@interface ViewController ()
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:glkView.context];

    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
//    self.baseEffect.constantColor = GLKVector4Make(1, 1, 1, 1);
//
//    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0, 0, 0, 1);

    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usage:GL_STATIC_DRAW];

    CGImageRef imageRef = [UIImage imageNamed:@"leaves.gif"].CGImage;
    AGLKTextureInfo *textureInfo = [AGLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];

    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;

    GLfloat aspectRatio = self.view.frame.size.width/(GLfloat)self.view.frame.size.height;
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeScale(1, aspectRatio, 1);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];

    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:GL_TRUE];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:GL_TRUE];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];
}
- (void)dealloc
{
    self.vertexBuffer = nil;
    [AGLKContext setCurrentContext:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
