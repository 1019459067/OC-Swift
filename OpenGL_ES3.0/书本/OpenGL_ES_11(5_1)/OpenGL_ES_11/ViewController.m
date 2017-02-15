//
//  ViewController.m
//  OpenGL_ES_11
//
//  Created by STMBP on 2017/2/12.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

#define NUM_FACES (8)

typedef struct
{
    GLKVector3  position;
    GLKVector3  normal;
}SceneVertex;

typedef struct
{
    SceneVertex vertices[3];
}SceneTriangle;

static SceneVertex vertexA = {{-0.5,  0.5, -0.5}, {0.0, 1.0}};
static SceneVertex vertexB = {{-0.5,  0.0, -0.5}, {0.0, 0.5}};
static SceneVertex vertexC = {{-0.5, -0.5, -0.5}, {0.0, 0.0}};
static SceneVertex vertexD = {{ 0.0,  0.5, -0.5}, {0.5, 1.0}};
static SceneVertex vertexE = {{ 0.0,  0.0,  0.0}, {0.5, 0.5}};
static SceneVertex vertexF = {{ 0.0, -0.5, -0.5}, {0.5, 0.0}};
static SceneVertex vertexG = {{ 0.5,  0.5, -0.5}, {1.0, 1.0}};
static SceneVertex vertexH = {{ 0.5,  0.0, -0.5}, {1.0, 0.5}};
static SceneVertex vertexI = {{ 0.5, -0.5, -0.5}, {1.0, 0.0}};

static SceneTriangle SceneTriangleMake(const SceneVertex vertexA,const SceneVertex vertexB,const SceneVertex vertexC);

@interface ViewController ()
{
    SceneTriangle triangles[NUM_FACES];
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (strong, nonatomic) GLKTextureInfo *blandTextureInfo;
@property (strong, nonatomic) GLKTextureInfo *interestingTextureInfo;
@property (assign, nonatomic) BOOL shouldUseDetailLighting;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:glkView.context];

    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1, 1, 1, 1);

        /// 整个场景被旋转并定位 以看到三角锥的高度变化
    {
        GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-60), 1, 0, 0);
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30), 0, 0, 1);
        modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0, 0, 0.25);

        self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
    }

    CGImageRef blandSimulatedLightingImageRef = [UIImage imageNamed:@"Lighting256x256"].CGImage;
    self.blandTextureInfo = [GLKTextureLoader textureWithCGImage:blandSimulatedLightingImageRef options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];
    CGImageRef interestingSimulatedLightingImageRef = [UIImage imageNamed:@"LightingDetail256x256"].CGImage;
    self.interestingTextureInfo = [GLKTextureLoader textureWithCGImage:interestingSimulatedLightingImageRef options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];

    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0, 0, 0, 1);

    triangles[0] = SceneTriangleMake(vertexA, vertexB, vertexD);
    triangles[1] = SceneTriangleMake(vertexB, vertexC, vertexF);
    triangles[2] = SceneTriangleMake(vertexD, vertexB, vertexE);
    triangles[3] = SceneTriangleMake(vertexE, vertexB, vertexF);
    triangles[4] = SceneTriangleMake(vertexD, vertexE, vertexH);
    triangles[5] = SceneTriangleMake(vertexE, vertexF, vertexH);
    triangles[6] = SceneTriangleMake(vertexG, vertexD, vertexH);
    triangles[7] = SceneTriangleMake(vertexH, vertexF, vertexI);

    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(triangles)/sizeof(SceneVertex) data:triangles usage:GL_DYNAMIC_DRAW];

    self.shouldUseDetailLighting = YES;
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    if (self.shouldUseDetailLighting)
    {
        self.baseEffect.texture2d0.name = self.interestingTextureInfo.name;
        self.baseEffect.texture2d0.target = self.interestingTextureInfo.target;
    }else
    {
        self.baseEffect.texture2d0.name = self.blandTextureInfo.name;
        self.baseEffect.texture2d0.target = self.blandTextureInfo.target;
    }

    [self.baseEffect prepareToDraw];

    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];

    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, position) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, normal) shouldEnable:YES];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(triangles)/sizeof(SceneVertex)];
}
- (void)setupUI
{
    UILabel *labelShowDetails = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, self.view.frame.size.width, 44)];
    labelShowDetails.text = @"Show Details";
    labelShowDetails.textColor = [UIColor whiteColor];
    [self.view addSubview:labelShowDetails];
    UISwitch *switchShowDetails = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelShowDetails.frame), CGRectGetMaxY(labelShowDetails.frame), 80, 44)];
    [switchShowDetails addTarget:self action:@selector(actionShowDetails:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchShowDetails];
    switchShowDetails.on = YES;
}
- (void)actionShowDetails:(UISwitch *)sender
{
    self.shouldUseDetailLighting = sender.isOn;
}

static SceneTriangle SceneTriangleMake(const SceneVertex vertexA,const SceneVertex vertexB,const SceneVertex vertexC)
{
    SceneTriangle result;
    result.vertices[0] = vertexA;
    result.vertices[1] = vertexB;
    result.vertices[2] = vertexC;
    return result;
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
