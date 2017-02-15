//
//  ViewController.m
//  OpenGL_ES_16
//
//  Created by STMBP on 2017/2/15.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sphere.h"

static const GLfloat  SceneEarthAxialTiltDeg = 23.5f;
static const GLfloat  SceneDaysPerMoonOrbit = 28.0f;
static const GLfloat  SceneMoonRadiusFractionOfEarth = 0.25;
static const GLfloat  SceneMoonDistanceFromEarth = 3.0;

@interface ViewController ()
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexPositionBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexNormalBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexTextureCoordBuffer;
@property (strong, nonatomic) GLKTextureInfo *earthTextureInfo;
@property (strong, nonatomic) GLKTextureInfo *moonTextureInfo;
@property (assign, nonatomic) GLKMatrixStackRef modelViewMatrixStack;
@property (assign, nonatomic) GLfloat earthRotationAngleDegrees;
@property (assign, nonatomic) GLfloat moonRotationAngleDegrees;
@end

@implementation ViewController

- (void)viewDidLoad {
    [self setupUI];
    [super viewDidLoad];
    self.modelViewMatrixStack = GLKMatrixStackCreate(kCFAllocatorDefault);

    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:glkView.context];
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat16;

    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1, 1, 1, 1);
    self.baseEffect.light0.position = GLKVector4Make(1, 0, 0, 0);
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.2, 0.2, 0.2, 1);

    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-1*4./3., 1*4./3., -1, 1, 1, 120);

    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0, 0, -5);
    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0, 0, 0, 1);

    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:3*sizeof(GL_FLOAT) numberOfVertices:sizeof(sphereVerts)/3.*sizeof(GL_FLOAT) data:sphereVerts usage:GL_STATIC_DRAW];
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:3*sizeof(GL_FLOAT) numberOfVertices:sizeof(sphereNormals)/3.*sizeof(GL_FLOAT) data:sphereNormals usage:GL_STATIC_DRAW];
    self.vertexTextureCoordBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:2*sizeof(GL_FLOAT) numberOfVertices:sizeof(sphereTexCoords)/2.*sizeof(GL_FLOAT) data:sphereTexCoords usage:GL_STATIC_DRAW];

    CGImageRef imageRefEarth = [UIImage imageNamed:@"Earth512x256.jpg"].CGImage;
    self.earthTextureInfo = [GLKTextureLoader textureWithCGImage:imageRefEarth options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];

    CGImageRef imageRefMoon = [UIImage imageNamed:@"Moon256x128"].CGImage;
    self.moonTextureInfo = [GLKTextureLoader textureWithCGImage:imageRefMoon options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];

    GLKMatrixStackLoadMatrix4(self.modelViewMatrixStack, self.baseEffect.transform.modelviewMatrix);

    self.moonRotationAngleDegrees = -20.f;

    [(AGLKContext *)glkView.context enable:GL_DEPTH_TEST];
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    self.earthRotationAngleDegrees += 360/60;
    self.moonRotationAngleDegrees += 360/60 /SceneDaysPerMoonOrbit;

    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];

    [self.vertexPositionBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.vertexNormalBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.vertexTextureCoordBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:0 shouldEnable:YES];

    [self drawEarth];
    [self drawMoon];

}
- (void)setupUI
{
    UILabel *labelSperspective = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 120, 44)];
    labelSperspective.text = @"sperspective";
    labelSperspective.textColor = [UIColor whiteColor];
    [self.view addSubview:labelSperspective];
    UISwitch *switchSperspective = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelSperspective.frame), CGRectGetMaxY(labelSperspective.frame), 80, 44)];
    [switchSperspective addTarget:self action:@selector(takeShouldUsePerspectiveFrom:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchSperspective];
}
- (void)takeShouldUsePerspectiveFrom:(UISwitch *)aControl
{
    GLfloat aspectRatio = ((GLKView *)self.view).drawableWidth / (float)((GLKView *)self.view).drawableHeight;
    if([aControl isOn])
    {
        self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeFrustum(-1.0 * aspectRatio,1.0 * aspectRatio,-1.0,1.0,1.0,120.0);
    }
    else
    {
        self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-1.0 * aspectRatio,1.0 * aspectRatio,-1.0,1.0,1.0,120.0);
    }
}

- (void)drawMoon
{
    self.baseEffect.texture2d0.name = self.moonTextureInfo.name;
    self.baseEffect.texture2d0.target = self.moonTextureInfo.target;

    GLKMatrixStackPush(self.modelViewMatrixStack);
    GLKMatrixStackRotate(self.modelViewMatrixStack, GLKMathDegreesToRadians(self.moonRotationAngleDegrees), 0, 1, 0);
    GLKMatrixStackTranslate(self.modelViewMatrixStack, 0, 0, SceneMoonDistanceFromEarth);
    GLKMatrixStackScale(self.modelViewMatrixStack, SceneMoonRadiusFractionOfEarth, SceneMoonRadiusFractionOfEarth, SceneMoonRadiusFractionOfEarth);
    GLKMatrixStackRotate(self.modelViewMatrixStack, GLKMathDegreesToRadians(self.moonRotationAngleDegrees), 0, 1, 0);

    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelViewMatrixStack);

    [self.baseEffect prepareToDraw];

    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sphereNumVerts];

    GLKMatrixStackPop(self.modelViewMatrixStack);

    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelViewMatrixStack);
}

- (void)drawEarth
{
    self.baseEffect.texture2d0.name = self.earthTextureInfo.name;
    self.baseEffect.texture2d0.target = self.earthTextureInfo.target;

    GLKMatrixStackPush(self.modelViewMatrixStack);
    GLKMatrixStackRotate(self.modelViewMatrixStack, GLKMathDegreesToRadians(SceneEarthAxialTiltDeg), 1, 0, 0);
    GLKMatrixStackRotate(self.modelViewMatrixStack, GLKMathDegreesToRadians(self.earthRotationAngleDegrees), 0, 1, 0);

    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelViewMatrixStack);

    [self.baseEffect prepareToDraw];

    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sphereNumVerts];

    GLKMatrixStackPop(self.modelViewMatrixStack);

    self.baseEffect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(self.modelViewMatrixStack);
}
- (void)dealloc
{
    self.vertexPositionBuffer = nil;
    self.vertexNormalBuffer = nil;
    self.vertexTextureCoordBuffer = nil;
    [AGLKContext setCurrentContext:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
