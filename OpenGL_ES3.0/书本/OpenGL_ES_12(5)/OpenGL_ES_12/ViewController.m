//
//  ViewController.m
//  OpenGL_ES_12
//
//  Created by STMBP on 2017/2/12.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sphere.h"

@interface ViewController ()
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexPositionBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexNormalBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexTextureCoordBuffer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:glkView.context];

    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat16;

    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7, 0.7, 0.7, 1);
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.2, 0.2, 0.2, 1);
    self.baseEffect.light0.position = GLKVector4Make(1, 0, -0.8, 0);

    CGImageRef imageRef = [UIImage imageNamed:@"Earth512x256.jpg"].CGImage;
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;

    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0, 0, 0, 1);

    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:3*sizeof(GLfloat) numberOfVertices:sizeof(sphereVerts)/3*sizeof(GLfloat) data:sphereVerts usage:GL_STATIC_DRAW];
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:3*sizeof(GLfloat) numberOfVertices:sizeof(sphereNormals)/3*sizeof(GLfloat) data:sphereNormals usage:GL_STATIC_DRAW];
    self.vertexTextureCoordBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:2*sizeof(GLfloat) numberOfVertices:sizeof(sphereTexCoords)/2*sizeof(GLfloat) data:sphereTexCoords usage:GL_STATIC_DRAW];

    [(AGLKContext *)glkView.context enable:GL_DEPTH_TEST];
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];

    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];

    [self.vertexPositionBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.vertexNormalBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.vertexTextureCoordBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:0 shouldEnable:YES];

    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sphereNumVerts];
}
- (void)dealloc
{
    self.vertexTextureCoordBuffer = nil;
    self.vertexNormalBuffer = nil;
    self.vertexPositionBuffer = nil;
    [AGLKContext setCurrentContext:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
