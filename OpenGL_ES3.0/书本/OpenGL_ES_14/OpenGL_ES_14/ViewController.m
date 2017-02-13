//
//  ViewController.m
//  OpenGL_ES_14
//
//  Created by STMBP on 2017/2/13.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "lowPolyAxesAndModels2.h"

typedef enum
{
    SceneTranslate = 0,
    SceneRotate,
    SceneScale,
} SceneTransformationSelector;

typedef enum
{
    SceneXAxis = 0,
    SceneYAxis,
    SceneZAxis,
} SceneTransformationAxisSelector;

@interface ViewController ()
{
    SceneTransformationSelector      transform1Type;
    SceneTransformationAxisSelector  transform1Axis;
    float                            transform1Value;
    SceneTransformationSelector      transform2Type;
    SceneTransformationAxisSelector  transform2Axis;
    float                            transform2Value;
    SceneTransformationSelector      transform3Type;
    SceneTransformationAxisSelector  transform3Axis;
    float                            transform3Value;
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexPositionBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexNormalBuffer;

@property (strong, nonatomic) UISlider *transform1ValueSlider;
@property (strong, nonatomic) UISlider *transform2ValueSlider;
@property (strong, nonatomic) UISlider *transform3ValueSlider;
@property (strong, nonatomic) UISegmentedControl *segmTransform1Type;
@property (strong, nonatomic) UISegmentedControl *segmTransform2Type;
@property (strong, nonatomic) UISegmentedControl *segmTransform3Type;
@property (strong, nonatomic) UISegmentedControl *segmTransform1TAxis;
@property (strong, nonatomic) UISegmentedControl *segmTransform2TAxis;
@property (strong, nonatomic) UISegmentedControl *segmTransform3TAxis;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:glkView.context];
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat16;

    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.4, 0.4, 0.4, 1);
    self.baseEffect.light0.position = GLKVector4Make(1, 0.8, 0.4, 0);

    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0, 0, 0, 1);

    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:3*sizeof(GLfloat) numberOfVertices:sizeof(lowPolyAxesAndModels2Verts)/3*sizeof(GLfloat) data:lowPolyAxesAndModels2Verts usage:GL_STATIC_DRAW];
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:3*sizeof(GLfloat) numberOfVertices:sizeof(lowPolyAxesAndModels2Normals)/3*sizeof(GLfloat) data:lowPolyAxesAndModels2Normals usage:GL_STATIC_DRAW];

    [(AGLKContext *)glkView.context enable:GL_DEPTH_TEST];

        ///
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(30), 1, 0, 0);
    modelviewMatrix = GLKMatrix4Rotate(modelviewMatrix, GLKMathDegreesToRadians(-30), 0, 1, 0);
    modelviewMatrix = GLKMatrix4Translate(modelviewMatrix, -0.25, 0, -0.2);
    self.baseEffect.transform.modelviewMatrix = modelviewMatrix;

    [((AGLKContext *)glkView.context) enable:GL_BLEND];
    [(AGLKContext *)glkView.context setBlendSourceFunction:GL_SRC_ALPHA destinationFunction:GL_ONE_MINUS_SRC_ALPHA];
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    const GLfloat aspectRatio = view.drawableWidth/(GLfloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-0.5*aspectRatio, 0.5*aspectRatio, -0.5, 0.5, -5, 5);

    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];

    [self.vertexPositionBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    [self.vertexNormalBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];

    GLKMatrix4 savedModelViewMatrix = self.baseEffect.transform.modelviewMatrix;
    GLKMatrix4 newModelViewMatrix = GLKMatrix4Multiply(savedModelViewMatrix, SceneMatrixForTransform(transform1Type, transform1Axis, transform1Value));
    newModelViewMatrix = GLKMatrix4Multiply(savedModelViewMatrix, SceneMatrixForTransform(transform2Type, transform2Axis, transform2Value));
    newModelViewMatrix = GLKMatrix4Multiply(savedModelViewMatrix, SceneMatrixForTransform(transform3Type, transform3Axis, transform3Value));

    self.baseEffect.transform.modelviewMatrix = newModelViewMatrix;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1, 1, 1, 1);
    [self.baseEffect prepareToDraw];
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:lowPolyAxesAndModels2NumVerts];

    self.baseEffect.transform.modelviewMatrix = savedModelViewMatrix;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1, 1, 0, 0.3);
    [self.baseEffect prepareToDraw];
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:lowPolyAxesAndModels2NumVerts];
}

- (void)setupUI
{
    UIButton *buttonResetIdentify = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonResetIdentify.frame = CGRectMake(0, self.view.frame.size.height-300, 150, 44);
    [buttonResetIdentify setTitle:@"Reset Identify" forState:UIControlStateNormal];
    [buttonResetIdentify setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonResetIdentify setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [buttonResetIdentify addTarget:self action:@selector(onActionResetIdentify:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonResetIdentify];

    NSArray *arrayType = @[@"T",@"R",@"S"];
    NSArray *arrayAxis = @[@"X",@"Y",@"Z"];

    self.segmTransform1Type = [self segmentedControlWithItems:arrayType frame:CGRectMake(10, CGRectGetMaxY(buttonResetIdentify.frame)+30, 100, 44) target:self action:@selector(takeTransform1TypeFrom:)];
    self.segmTransform1TAxis = [self segmentedControlWithItems:arrayAxis frame:CGRectMake(CGRectGetMaxX(self.segmTransform1Type.frame)+10, CGRectGetMinY(self.segmTransform1Type.frame), CGRectGetWidth(self.segmTransform1Type.frame), CGRectGetHeight(self.segmTransform1Type.frame)) target:self action:@selector(takeTransform1AxisFrom:)];
    self.transform1ValueSlider = [self sliderWithFrame:CGRectMake(CGRectGetMaxX(self.segmTransform1TAxis.frame)+10, CGRectGetMinY(self.segmTransform1TAxis.frame), self.view.frame.size.width-(CGRectGetMaxX(self.segmTransform1TAxis.frame)+15), CGRectGetHeight(self.segmTransform1Type.frame)) target:self action:@selector(takeTransform1ValueFrom:)];


    self.segmTransform2Type = [self segmentedControlWithItems:arrayType frame:CGRectMake(CGRectGetMinX(self.segmTransform1Type.frame), CGRectGetMaxY(self.segmTransform1Type.frame)+20, CGRectGetWidth(self.segmTransform1Type.frame), CGRectGetHeight(self.segmTransform1Type.frame)) target:self action:@selector(takeTransform2TypeFrom:)];
    self.segmTransform2TAxis = [self segmentedControlWithItems:arrayAxis frame:CGRectMake(CGRectGetMaxX(self.segmTransform2Type.frame)+10, CGRectGetMinY(self.segmTransform2Type.frame), CGRectGetWidth(self.segmTransform1Type.frame), CGRectGetHeight(self.segmTransform1Type.frame)) target:self action:@selector(takeTransform2AxisFrom:)];
    self.transform2ValueSlider = [self sliderWithFrame:CGRectMake(CGRectGetMaxX(self.segmTransform2TAxis.frame)+10, CGRectGetMinY(self.segmTransform2TAxis.frame), self.view.frame.size.width-(CGRectGetMaxX(self.segmTransform1TAxis.frame)+15), CGRectGetHeight(self.segmTransform1Type.frame)) target:self action:@selector(takeTransform2ValueFrom:)];


    self.segmTransform3Type = [self segmentedControlWithItems:arrayType frame:CGRectMake(CGRectGetMinX(self.segmTransform1Type.frame), CGRectGetMaxY(self.segmTransform2Type.frame)+20, CGRectGetWidth(self.segmTransform1Type.frame), CGRectGetHeight(self.segmTransform1Type.frame)) target:self action:@selector(takeTransform3TypeFrom:)];
    self.segmTransform3TAxis = [self segmentedControlWithItems:arrayAxis frame:CGRectMake(CGRectGetMaxX(self.segmTransform3Type.frame)+10, CGRectGetMinY(self.segmTransform3Type.frame), CGRectGetWidth(self.segmTransform1Type.frame), CGRectGetHeight(self.segmTransform1Type.frame)) target:self action:@selector(takeTransform3AxisFrom:)];
    self.transform3ValueSlider = [self sliderWithFrame:CGRectMake(CGRectGetMaxX(self.segmTransform3TAxis.frame)+10, CGRectGetMinY(self.segmTransform3TAxis.frame), self.view.frame.size.width-(CGRectGetMaxX(self.segmTransform1TAxis.frame)+15), CGRectGetHeight(self.segmTransform1Type.frame)) target:self action:@selector(takeTransform3ValueFrom:)];

}
- (UISlider *)sliderWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    UISlider *slider = [[UISlider alloc]initWithFrame:frame];
    [slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    slider.minimumValue = -1;
    return slider;
}
- (UISegmentedControl *)segmentedControlWithItems:(NSArray *)items frame:(CGRect)frame target:(id)target action:(SEL)action
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:items];
    segmentedControl.frame = frame;
    [segmentedControl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    segmentedControl.selectedSegmentIndex = 0;
    return segmentedControl;
}
- (void)takeTransform3ValueFrom:(UISlider *)aControl
{
    transform3Value = [aControl value];
}
- (void)takeTransform2ValueFrom:(UISlider *)aControl
{
    transform2Value = [aControl value];
}
- (void)takeTransform1ValueFrom:(UISlider *)aControl
{
    transform1Value = [aControl value];
}
- (void)takeTransform3AxisFrom:(UISegmentedControl *)aControl
{
    transform3Axis = (SceneTransformationAxisSelector)[aControl selectedSegmentIndex];
}
- (void)takeTransform2AxisFrom:(UISegmentedControl *)aControl
{
    transform2Axis = (SceneTransformationAxisSelector)[aControl selectedSegmentIndex];
}
- (void)takeTransform1AxisFrom:(UISegmentedControl *)aControl
{
    transform1Axis = (SceneTransformationAxisSelector)[aControl selectedSegmentIndex];
}
- (void)takeTransform3TypeFrom:(UISegmentedControl *)aControl
{
    transform3Type = (SceneTransformationSelector)[aControl selectedSegmentIndex];
}
- (void)takeTransform2TypeFrom:(UISegmentedControl *)aControl
{
    transform2Type = (SceneTransformationSelector)[aControl selectedSegmentIndex];
}
- (void)takeTransform1TypeFrom:(UISegmentedControl *)aControl
{
    transform1Type = (SceneTransformationSelector)[aControl selectedSegmentIndex];
}
- (void)onActionResetIdentify:(UIButton *)sender
{
    [self.transform1ValueSlider setValue:0.0];
    [self.transform2ValueSlider setValue:0.0];
    [self.transform3ValueSlider setValue:0.0];
    transform1Value = 0.0;
    transform2Value = 0.0;
    transform3Value = 0.0;
}


static GLKMatrix4 SceneMatrixForTransform(SceneTransformationSelector type,SceneTransformationAxisSelector axis,float value)
{
    GLKMatrix4 result = GLKMatrix4Identity;

    switch (type) {
        case SceneRotate:
            switch (axis) {
                case SceneXAxis:
                    result = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(180.0 * value),1.0,0.0,0.0);
                    break;
                case SceneYAxis:
                    result = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(180.0 * value),0.0,1.0,0.0);
                    break;
                case SceneZAxis:
                default:
                    result = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(180.0 * value),0.0,0.0,1.0);
                    break;
            }
            break;
        case SceneScale:
            switch (axis) {
                case SceneXAxis:
                    result = GLKMatrix4MakeScale(1.0 + value,1.0,1.0);
                    break;
                case SceneYAxis:
                    result = GLKMatrix4MakeScale(1.0,1.0 + value,1.0);
                    break;
                case SceneZAxis:
                default:
                    result = GLKMatrix4MakeScale(1.0,1.0,1.0 + value);
                    break;
            }
            break;
        default:
            switch (axis) {
                case SceneXAxis:
                    result = GLKMatrix4MakeTranslation(0.3 * value, 0.0,0.0);
                    break;
                case SceneYAxis:
                    result = GLKMatrix4MakeTranslation(0.0,0.3 * value,0.0);
                    break;
                case SceneZAxis:
                default:
                    result = GLKMatrix4MakeTranslation(0.0,0.0,0.3 * value);
                    break;
            }
            break;
    }
    
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
