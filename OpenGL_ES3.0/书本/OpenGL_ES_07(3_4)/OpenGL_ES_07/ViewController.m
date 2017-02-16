//
//  ViewController.m
//  OpenGL_ES_07
//
//  Created by STMBP on 2017/2/8.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

static const SceneVertex vertices[] =
{
    {{-1.0f, -1.f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 1.0f, -1.f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  1.f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -1.f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-1.0f,  1.f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  1.f, 0.0f}, {1.0f, 1.0f}},
};

@interface ViewController ()

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *verterBuffer;
@property (strong, nonatomic) GLKTextureInfo *textureInfo0;
@property (strong, nonatomic) GLKTextureInfo *textureInfo1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:glkView.context];

    self.baseEffect = [[GLKBaseEffect alloc]init];
//    self.baseEffect.useConstantColor = GL_TRUE;
//    self.baseEffect.constantColor = GLKVector4Make(1, 1, 1, 1);
//    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0, 0, 0, 1);

    self.verterBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usage:GL_STATIC_DRAW];

    CGImageRef imageRef0 = [UIImage imageNamed:@"leaves.gif"].CGImage;
    self.textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];

    CGImageRef imageRef1 = [UIImage imageNamed:@"beetle"].CGImage;
    self.textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    GLfloat aspectRatio = self.view.frame.size.width/(GLfloat)self.view.frame.size.height;
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeScale(1, aspectRatio, 1);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];

    [self.verterBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.verterBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];

    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    [self.baseEffect prepareToDraw];
    [self.verterBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];

    self.baseEffect.texture2d0.name = self.textureInfo1.name;
    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];
    [self.verterBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];
}

- (void)dealloc
{
    self.verterBuffer = nil;
    [EAGLContext setCurrentContext:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
