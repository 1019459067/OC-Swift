//
//  ViewController.m
//  OpenGL_ES_06
//
//  Created by STMBP on 2017/2/7.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

    /// sizeof(SceneVertex) = 24 = 3*4 *2
typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;
    /// sizeof(vertices) = 72 = 3*2 * 3 * 4
static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

static GLKVector3 movementVectors[3] =
{
    {-0.02f,  -0.01f,  0.0f},
    { 0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f,  0.0f},
};

@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParamter:(GLenum)parameterID value:(GLint)value
{
    glBindTexture(self.target, self.name);
    glTexParameterf(self.target, parameterID, value);
}

@end
@interface ViewController ()
{
    BOOL _bShouldAnimate;
    BOOL _bShouldRepeatTexture;
    BOOL _bShouldUseLinearFilter;
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (assign, nonatomic) GLfloat sCoordinateOffset;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _bShouldAnimate = YES;
    _bShouldRepeatTexture = YES;

    [self setupUI];
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:glkView.context];

    self.baseEffect = [[GLKBaseEffect alloc]init];
//    self.baseEffect.useConstantColor = GL_TRUE;
//    self.baseEffect.constantColor = GLKVector4Make(1, 1, 1, 1);
//
//    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0, 0, 0, 1);

    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usage:GL_DYNAMIC_DRAW];

    CGImageRef imageRef = [UIImage imageNamed:@"grid.png"].CGImage;
    GLKTextureInfo *textuerInfo = [GLKTextureLoader textureWithCGImage:imageRef options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];

    self.baseEffect.texture2d0.name = textuerInfo.name;
    self.baseEffect.texture2d0.target = textuerInfo.target;

    GLfloat aspectRatio = self.view.frame.size.width/(GLfloat)self.view.frame.size.height;
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeScale(1, aspectRatio, 1);
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];

    [(AGLKContext*)view.context clear:GL_COLOR_BUFFER_BIT];

    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}
- (void)update
{
    [self updateAnimatedVertexPositions];
    [self updateTextureParameters];
    [self updateCoordinate_S];

    [self.vertexBuffer reinitWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices];
}
- (void)updateCoordinate_S
{
        /// 纹理坐标 s轴 转换
    for (int i = 0; i < sizeof(vertices)/sizeof(SceneVertex); i++)
    {
        vertices[i].textureCoords.s = defaultVertices[i].textureCoords.s+self.sCoordinateOffset;
    }
}
- (void)updateTextureParameters
{
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, (_bShouldRepeatTexture?GL_REPEAT:GL_CLAMP_TO_EDGE));
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, (_bShouldUseLinearFilter?GL_LINEAR:GL_NEAREST));

    [self.baseEffect.texture2d0 aglkSetParamter:GL_TEXTURE_WRAP_S value:(_bShouldRepeatTexture?GL_REPEAT:GL_CLAMP_TO_EDGE)];
    [self.baseEffect.texture2d0 aglkSetParamter:GL_TEXTURE_MAG_FILTER value:(_bShouldUseLinearFilter?GL_LINEAR:GL_NEAREST)];
}
- (void)updateAnimatedVertexPositions
{
    if (_bShouldAnimate)
    {
        for (int i = 0; i < sizeof(vertices)/sizeof(SceneVertex); i++)
        {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if (vertices[i].positionCoords.x >= 1.0 || vertices[i].positionCoords.x <= -1)
            {
                movementVectors[i].x = -movementVectors[i].x;
            }
            vertices[i].positionCoords.y += movementVectors[i].y;
            if (vertices[i].positionCoords.y >= 1.0 || vertices[i].positionCoords.y <= -1)
            {
                movementVectors[i].y = -movementVectors[i].y;
            }
            vertices[i].positionCoords.z += movementVectors[i].z;
            if (vertices[i].positionCoords.z >= 1.0 || vertices[i].positionCoords.z <= -1)
            {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    }else
    {
        for (int i = 0; i < sizeof(vertices)/sizeof(SceneVertex); i++)
        {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
}


- (void)setupUI
{
    UILabel *labelFliter = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 120, 44)];
    labelFliter.text = @"Linear Filter";
    labelFliter.textColor = [UIColor whiteColor];
    [self.view addSubview:labelFliter];
    UISwitch *switchFilter = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelFliter.frame), CGRectGetMaxY(labelFliter.frame), 80, 44)];
    [switchFilter addTarget:self action:@selector(actionFilter:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchFilter];

    UILabel *labelAnimation = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(switchFilter.frame)+10, 120, 44)];
    labelAnimation.text = @"Animation";
    labelAnimation.textColor = [UIColor whiteColor];
    [self.view addSubview:labelAnimation];
    UISwitch *switchAnimation = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelAnimation.frame), CGRectGetMaxY(labelAnimation.frame), 80, 44)];
    [switchAnimation addTarget:self action:@selector(actionAnimation:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchAnimation];

    UILabel *labelTexture = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(switchAnimation.frame)+10, 120, 44)];
    labelTexture.text = @"Repeat Texture";
    labelTexture.textColor = [UIColor whiteColor];
    [self.view addSubview:labelTexture];
    UISwitch *switchTexture = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelTexture.frame), CGRectGetMaxY(labelTexture.frame), 80, 44)];
    [switchTexture addTarget:self action:@selector(actionTexture:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchTexture];

    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMinX(switchTexture.frame), CGRectGetMaxY(switchTexture.frame), self.view.frame.size.width-2*CGRectGetMinX(switchTexture.frame), 44)];
    [slider addTarget:self action:@selector(actionSlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    slider.minimumValue = -1;

    [switchAnimation setOn:_bShouldAnimate];
    [switchTexture setOn:_bShouldRepeatTexture];
}
- (void)actionFilter:(UISwitch *)sender
{
    _bShouldUseLinearFilter = sender.isOn;
}
- (void)actionAnimation:(UISwitch *)sender
{
    _bShouldAnimate = sender.isOn;
}
- (void)actionTexture:(UISwitch *)sender
{
    _bShouldRepeatTexture = sender.isOn;
}
- (void)actionSlider:(UISlider *)sender
{
    self.sCoordinateOffset = sender.value;
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
