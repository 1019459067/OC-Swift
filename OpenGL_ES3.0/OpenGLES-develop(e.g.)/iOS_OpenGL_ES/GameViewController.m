//
//  GameViewController.m
//  iOS_OPenGL_ES
//
//  Created by Yuanfei He on 16/4/12.
//  Copyright © 2016年 Yuanfei He. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#include <stdio.h>
#define BUFFER_OFFSET(i) ((char *)NULL + (i))
// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

//static GLfloat interwinded[]={
//    -1.0f,-1.0f,0.0f,
//    1.0f,-1.0f,0.0f,
//    0.0f,1.0f,0.0f,
//};

static GLfloat interwinded[] = {
    -1.0f,-1.0f,-1.0f, // triangle 1 : begin
    -1.0f,-1.0f, 1.0f,
    -1.0f, 1.0f, 1.0f, // triangle 1 : end
    1.0f, 1.0f,-1.0f, // triangle 2 : begin
    -1.0f,-1.0f,-1.0f,
    -1.0f, 1.0f,-1.0f, // triangle 2 : end
    1.0f,-1.0f, 1.0f,
    -1.0f,-1.0f,-1.0f,
    1.0f,-1.0f,-1.0f,
    1.0f, 1.0f,-1.0f,
    1.0f,-1.0f,-1.0f,
    -1.0f,-1.0f,-1.0f,
    -1.0f,-1.0f,-1.0f,
    -1.0f, 1.0f, 1.0f,
    -1.0f, 1.0f,-1.0f,
    1.0f,-1.0f, 1.0f,
    -1.0f,-1.0f, 1.0f,
    -1.0f,-1.0f,-1.0f,
    -1.0f, 1.0f, 1.0f,
    -1.0f,-1.0f, 1.0f,
    1.0f,-1.0f, 1.0f,
    1.0f, 1.0f, 1.0f,
    1.0f,-1.0f,-1.0f,
    1.0f, 1.0f,-1.0f,
    1.0f,-1.0f,-1.0f,
    1.0f, 1.0f, 1.0f,
    1.0f,-1.0f, 1.0f,
    1.0f, 1.0f, 1.0f,
    1.0f, 1.0f,-1.0f,
    -1.0f, 1.0f,-1.0f,
    1.0f, 1.0f, 1.0f,
    -1.0f, 1.0f,-1.0f,
    -1.0f, 1.0f, 1.0f,
    1.0f, 1.0f, 1.0f,
    -1.0f, 1.0f, 1.0f,
    1.0f,-1.0f, 1.0f
};


//static GLfloat interwinded[] = {
//    0.0f,0.0f,1.0f,
//    1.0f,0.0f,1.0f,
//    0.0f,1.0f,1.0f,
//    1.0f,1.0f,1.0f,
//};

//static GLfloat color_val[]={
//    1.0f,0.0f,0.0f,1.0f,
//    1.0f,0.0f,1.0f,1.0f,
//    0.0f,0.0f,1.0f,1.0f,
//};


static  GLfloat color_val[] = {
    0.583f, 0.771f, 0.014f,1.0f,
    0.609f, 0.115f, 0.436f,1.0f,
    0.327f, 0.483f, 0.844f,1.0f,
    0.822f, 0.569f, 0.201f,1.0f,
    0.435f, 0.602f, 0.223f,1.0f,
    0.310f, 0.747f, 0.185f,1.0f,
    0.597f, 0.770f, 0.761f,1.0f,
    0.559f, 0.436f, 0.730f,1.0f,
    0.359f, 0.583f, 0.152f,1.0f,
    0.483f, 0.596f, 0.789f,1.0f,
    0.559f, 0.861f, 0.639f,1.0f,
    0.195f, 0.548f, 0.859f,1.0f,
    0.014f, 0.184f, 0.576f,1.0f,
    0.771f, 0.328f, 0.970f,1.0f,
    0.406f, 0.615f, 0.116f,1.0f,
    0.676f, 0.977f, 0.133f,1.0f,
    0.971f, 0.572f, 0.833f,1.0f,
    0.140f, 0.616f, 0.489f,1.0f,
    0.997f, 0.513f, 0.064f,1.0f,
    0.945f, 0.719f, 0.592f,1.0f,
    0.543f, 0.021f, 0.978f,1.0f,
    0.279f, 0.317f, 0.505f,1.0f,
    0.167f, 0.620f, 0.077f,1.0f,
    0.347f, 0.857f, 0.137f,1.0f,
    0.055f, 0.953f, 0.042f,1.0f,
    0.714f, 0.505f, 0.345f,1.0f,
    0.783f, 0.290f, 0.734f,1.0f,
    0.722f, 0.645f, 0.174f,1.0f,
    0.302f, 0.455f, 0.848f,1.0f,
    0.225f, 0.587f, 0.040f,1.0f,
    0.517f, 0.713f, 0.338f,1.0f,
    0.053f, 0.959f, 0.120f,1.0f,
    0.393f, 0.621f, 0.362f,1.0f,
    0.673f, 0.211f, 0.457f,1.0f,
    0.820f, 0.883f, 0.371f,1.0f,
    0.982f, 0.099f, 0.879f,1.0f,
};

//static GLfloat color_val[] = {
//    1.0f,0.0f,0.0f,1.0f,
//    1.0f,0.0f,0.0f,1.0f,
//    1.0f,1.0f,0.0f,1.0f,
//    1.0f,1.0f,0.0f,1.0f,
//    1.0f,1.0f,0.0f,1.0f,
//    1.0f,1.0f,0.0f,1.0f
//};

static const GLfloat g_uv_buffer_data[] = {
    0.0f, 0.0f,
        1.0f, 0.0f, 
        0.0f, 1.0f,
        1.0f, 1.0f,
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0, 0.0f,
    1.0f, 1.0f,
    0.667969f, 1.0f-0.671889f,
    1.000023f, 1.0f-0.000013f,
    0.668104f, 1.0f-0.000013f,
    0.667979f, 1.0f-0.335851f,
    0.000059f, 1.0f-0.000004f,
    0.335973f, 1.0f-0.335903f,
    0.336098f, 1.0f-0.000071f,
    0.667979f, 1.0f-0.335851f,
    0.335973f, 1.0f-0.335903f,
    0.336024f, 1.0f-0.671877f,
    1.000004f, 1.0f-0.671847f,
    0.999958f, 1.0f-0.336064f,
    0.667979f, 1.0f-0.335851f,
    0.668104f, 1.0f-0.000013f,
    0.335973f, 1.0f-0.335903f,
    0.667979f, 1.0f-0.335851f,
    0.335973f, 1.0f-0.335903f,
    0.668104f, 1.0f-0.000013f,
    0.336098f, 1.0f-0.000071f,
    0.000103f, 1.0f-0.336048f,
    0.000004f, 1.0f-0.671870f,
    0.336024f, 1.0f-0.671877f,
    0.000103f, 1.0f-0.336048f,
    0.336024f, 1.0f-0.671877f,
    0.335973f, 1.0f-0.335903f,
    0.667969f, 1.0f-0.671889f,
    1.000004f, 1.0f-0.671847f,
    0.667979f, 1.0f-0.335851f
};

//static const GLfloat g_uv_buffer_data[] = {
//    0.0f, 0.0f,
//    1.0f, 0.0f,
//    0.0f, 1.0f,
//    1.0f, 1.0f,
//};

@interface GameViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _colorBuffer;
    GLuint _textureBuffer;
    
    double horizontalAngle;
    double verticalAngle;
    
    GLuint transformLoc;
    
    GLKVector3 cameraPos;
    GLKVector3 cameraFront;
    GLKVector3 cameraUP;
    
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (IBAction)Right:(id)sender;
- (IBAction)Left:(id)sender;
- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
-(void) loadTexture;
-(void) setupTouch:(UIView*)view;
-(void)respodToTapGesture:(UITapGestureRecognizer*)recognizer;
@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    [self setupTouch: view];
}
//设置View Touch事件
-(void)setupTouch:(UIView*)view
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respodToTapGesture:)];
    
    tapRecognizer.numberOfTapsRequired=1;
    [view addGestureRecognizer:tapRecognizer];
}
-(void)respodToTapGesture: (UITapGestureRecognizer*)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    NSLog(@"touch x:%f,y:%f",location.x,location.y);
    CGFloat width=self.view.bounds.size.width;
    CGFloat height=self.view.bounds.size.height;
    GLKVector3 crossVec3 = GLKVector3CrossProduct(cameraFront,cameraUP);
    
    if (height*0.5>location.y) {
        
        if (location.x<width*0.5) {
            
            
            cameraPos =GLKVector3Subtract(cameraPos, GLKVector3Normalize(crossVec3));
            
        }else if(location.x>=width*0.5){
            cameraPos =GLKVector3Add(cameraPos, crossVec3);
        }
    }else{
        
        if(location.x<width*0.5)
        {
            cameraPos=GLKVector3Add(cameraPos, GLKVector3MultiplyScalar(cameraPos, 0.05f));
            
        }else if(location.x>=width*0.5){
            cameraPos=GLKVector3Subtract(cameraPos, GLKVector3MultiplyScalar(cameraPos, 0.05f));
        }
    }
    
    
    
    
    
}
- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)Right:(id)sender {
    NSLog(@"Touch Right");
}

- (IBAction)Left:(id)sender {
    NSLog(@"Left Touch");
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    for (int i=0; i<108; i++) {
        GLfloat value = interwinded[i];
        interwinded[i]=(GLfloat)(value*0.3);
    }
    
    [self loadShaders];
    
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_LESS);
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(interwinded), interwinded, GL_STATIC_DRAW);
    
        glGenBuffers(1, &_colorBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(color_val), color_val, GL_STATIC_DRAW);
    
        glGenBuffers(1, &_textureBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _textureBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(g_uv_buffer_data), g_uv_buffer_data, GL_STATIC_DRAW);
    
    
//    [self loadTexture];
    
    
    cameraPos=GLKVector3Make(0.0f, 0.0f, 3.0f);
    cameraFront =GLKVector3Make(0.0f, 0.0f, -0.5f);
    cameraUP=GLKVector3Make(0.0f, 1.0f, 0.0f);

}

-(void) loadTexture
{
    //Texture Data
    //    GLKTextureInfo *spriteTexture;
    //    NSError *theError;
    //
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Sprite" ofType:@"png"]; // 1
    //
    //    spriteTexture = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:&theError]; // 2
    //    glBindTexture(spriteTexture.target, spriteTexture.name); // 3
   NSString *loap_path = [[NSBundle mainBundle] pathForResource:@"loap" ofType:@"jpg" inDirectory:@"Resouces"];
//    const char* c_path = [loap_path cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
//    int width=400,height=400;
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:loap_path];
    
    CGImageRef cgImageRef = [imgFromUrl3 CGImage];
    GLuint width = (GLuint)CGImageGetWidth(cgImageRef);
    GLuint height = (GLuint)CGImageGetHeight(cgImageRef);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc(width * height * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);
    CGContextDrawImage(context, rect, cgImageRef);

    glEnable(GL_TEXTURE_2D);
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    /**
     *  纹理过滤函数
     *  图象从纹理图象空间映射到帧缓冲图象空间(映射需要重新构造纹理图像,这样就会造成应用到多边形上的图像失真),
     *  这时就可用glTexParmeteri()函数来确定如何把纹理象素映射成像素.
     *  如何把图像从纹理图像空间映射到帧缓冲图像空间（即如何把纹理像素映射成像素）
     */
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE); // S方向上的贴图模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE); // T方向上的贴图模式
    // 线性过滤：使用距离当前渲染像素中心最近的4个纹理像素加权平均值
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    /**
     *  将图像数据传递给到GL_TEXTURE_2D中, 因其于textureID纹理对象已经绑定，所以即传递给了textureID纹理对象中。
     *  glTexImage2d会将图像数据从CPU内存通过PCIE上传到GPU内存。
     *  不使用PBO时它是一个阻塞CPU的函数，数据量大会卡。
     */
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    glDisable(GL_TEXTURE_2D);
//    glBindTexture(GL_TEXTURE_2D, 0); //解绑
//    CGContextRelease(context);
//    free(imageData);
}
- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    verticalAngle+=0.2;
    horizontalAngle+=0.1;
    
    GLKVector3 direction= GLKVector3Make(cos(verticalAngle)*sin(horizontalAngle),
                                         sin(verticalAngle),
                                         cos(verticalAngle)*cos(horizontalAngle)
                                         );
    
    GLKVector3 right=GLKVector3Make(sin(horizontalAngle*3.14f/2.0f),
                                    0,
                                    cos(horizontalAngle-3.14f/2.0f)
                                    );
    
    GLKVector3 up = GLKVector3CrossProduct(direction, right);
    
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0f), aspect, 0.1f, 100.0f);
    //摄像机的位置
    GLKVector3 position = cameraPos;//GLKVector3Make(camX, 0, camz);
   // GLKVector3 carmeFront = GLKVector3Make(0.0f,0.0f,-1.0f);
    GLKVector3 centent = GLKVector3Add(cameraFront,cameraPos);//GLKVector3Make(0, 0, 0);
    up=cameraUP;
    
    GLKMatrix4 viewMatrix=GLKMatrix4MakeLookAt(
                                               position.x,position.y,position.z,
                                               centent.x,centent.y,centent.z,
                                               up.x,up.y,up.z);
    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
   
    //缩放
    modelViewMatrix=GLKMatrix4Scale(modelViewMatrix, 0.5f, 0.5f, 1.0f);
    //平移
    GLKVector3 moveValue = GLKVector3Make(0.0f, 0, 0);
    modelViewMatrix = GLKMatrix4TranslateWithVector3(modelViewMatrix, moveValue);

    //旋转
//    _rotation =GLKMathDegreesToRadians(10);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 0.0f, 0.0f);
    
    
       projectionMatrix = GLKMatrix4Multiply(projectionMatrix, viewMatrix);
    
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // Drawing code here.

    
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE,0, BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(1);
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(2);
    glBindBuffer(GL_ARRAY_BUFFER, _textureBuffer);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    
    
    glDrawArrays(GL_TRIANGLES, 0, 12*3);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 12*3);
    glDisableVertexAttribArray(0);
    glUseProgram(_program); //use link programe
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
//     glDisableVertexAttribArray(1);
    glFlush();

    
}
#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"vertexShader" ofType:@"vsh" inDirectory:@"Shaders"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"fragmenShader" ofType:@"fsh" inDirectory:@"Shaders"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, 1, "color");
    glBindAttribLocation(_program, 2, "texture_coord");
    glGetUniformLocation(_program, "mytextureSampler");
    
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
//    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
