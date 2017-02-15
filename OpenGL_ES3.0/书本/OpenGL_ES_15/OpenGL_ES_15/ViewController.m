//
//  ViewController.m
//  OpenGL_ES_15
//
//  Created by STMBP on 2017/2/14.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKTextureTransformBaseEffect.h"

typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

static const SceneVertex vertices[] =
{
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};
@interface ViewController ()
@property (strong, nonatomic) AGLKTextureTransformBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (assign, nonatomic) float textureScaleFactor;
@property (assign, nonatomic) float textureAngle;
@property (assign, nonatomic) GLKMatrixStackRef textureMatrixStack;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.textureMatrixStack = GLKMatrixStackCreate(kCFAllocatorDefault);

    self.textureScaleFactor = 1.0;

    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:glkView.context];

    self.baseEffect = [[AGLKTextureTransformBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1, 1, 1, 1);
    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0, 0, 0, 1);

    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usage:GL_STATIC_DRAW];

    CGImageRef imageRef0 = [UIImage imageNamed:@"leaves.gif"].CGImage;
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];

    self.baseEffect.texture2d0.name = textureInfo0.name;
    self.baseEffect.texture2d0.target = textureInfo0.target;
    self.baseEffect.texture2d0.enabled = GL_TRUE;

    CGImageRef imageRef1 = [UIImage imageNamed:@"beetle"].CGImage;
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];

    self.baseEffect.texture2d1.name = textureInfo1.name;
    self.baseEffect.texture2d1.target = textureInfo1.target;
    self.baseEffect.texture2d1.enabled = GL_TRUE;

    [self.baseEffect.texture2d1 aglkSetParameter:GL_TEXTURE_WRAP_S value:GL_REPEAT];
    [self.baseEffect.texture2d1 aglkSetParameter:GL_TEXTURE_WRAP_T value:GL_REPEAT];

    GLKMatrixStackLoadMatrix4(self.textureMatrixStack, self.baseEffect.textureMatrix2d1);
}
- (void)setupUI
{
    UILabel *labelScale = [self labelWithFrame:CGRectMake(30, self.view.frame.size.height-200, 60, 44) text:@"Scale"];
    UISlider *sliderScale = [self sliderWithFrame:CGRectMake(CGRectGetMaxX(labelScale.frame)+10, CGRectGetMinY(labelScale.frame), self.view.frame.size.width-(CGRectGetMaxX(labelScale.frame)+15), CGRectGetHeight(labelScale.frame)) target:self action:@selector(takeTextureScaleFactorFrom:)];
    sliderScale.minimumValue = 1/3.;
    sliderScale.maximumValue = 3;
    sliderScale.value = 1;

    UILabel *labelRotate = [self labelWithFrame:CGRectMake(CGRectGetMinX(labelScale.frame), CGRectGetMaxY(labelScale.frame)+20, CGRectGetWidth(labelScale.frame), CGRectGetHeight(labelScale.frame)) text:@"Rotate"];
    UISlider *sliderRotate = [self sliderWithFrame:CGRectMake(CGRectGetMaxX(labelRotate.frame)+10, CGRectGetMinY(labelRotate.frame), CGRectGetWidth(sliderScale.frame), CGRectGetHeight(sliderScale.frame)) target:self action:@selector(takeTextureAngleFrom:)];
    sliderRotate.minimumValue = -180;
    sliderRotate.maximumValue = 180;
    sliderRotate.value = 0;

}
- (void)takeTextureScaleFactorFrom:(UISlider *)aControl
{
    self.textureScaleFactor = [aControl value];
}
- (void)takeTextureAngleFrom:(UISlider *)aControl
{
    self.textureAngle = [aControl value];
}
- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    return label;
}
- (UISlider *)sliderWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    UISlider *slider = [[UISlider alloc]initWithFrame:frame];
    [slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    slider.minimumValue = -1;
    return slider;
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];

    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];

    GLKMatrixStackPush(self.textureMatrixStack);
    GLKMatrixStackTranslate(self.textureMatrixStack, 0.5, 0.5, 0);
    GLKMatrixStackScale(self.textureMatrixStack, self.textureScaleFactor, self.textureScaleFactor, 1);
    GLKMatrixStackRotate(self.textureMatrixStack, GLKMathDegreesToRadians(self.textureAngle), 0, 0, 1);
    GLKMatrixStackTranslate(self.textureMatrixStack, -0.5, -0.5, 0);

    self.baseEffect.textureMatrix2d1 = GLKMatrixStackGetMatrix4(self.textureMatrixStack);

    [self.baseEffect prepareToDrawMultiTextures];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];

    GLKMatrixStackPop(self.textureMatrixStack);
    self.baseEffect.textureMatrix2d1 = GLKMatrixStackGetMatrix4(self.textureMatrixStack);
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
