//
//  ViewController.m
//  OpenGL_ES_09
//
//  Created by STMBP on 2017/2/9.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value;
{
    glBindTexture(self.target, self.name);
    glTexParameteri(self.target,parameterID,value);
}

@end
typedef struct {
    GLKVector3  positionCoords;
    GLKVector3  normalCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

static const SceneVertex vertices[] =
{
    {{ 0.5f, -0.5f, -0.5f}, { 1.0f,  0.0f,  0.0f}, {0.0f, 0.0f}},
    {{ 0.5f,  0.5f, -0.5f}, { 1.0f,  0.0f,  0.0f}, {1.0f, 0.0f}},
    {{ 0.5f, -0.5f,  0.5f}, { 1.0f,  0.0f,  0.0f}, {0.0f, 1.0f}},
    {{ 0.5f, -0.5f,  0.5f}, { 1.0f,  0.0f,  0.0f}, {0.0f, 1.0f}},
    {{ 0.5f,  0.5f,  0.5f}, { 1.0f,  0.0f,  0.0f}, {1.0f, 1.0f}},
    {{ 0.5f,  0.5f, -0.5f}, { 1.0f,  0.0f,  0.0f}, {1.0f, 0.0f}},

    {{ 0.5f,  0.5f, -0.5f}, { 0.0f,  1.0f,  0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, -0.5f}, { 0.0f,  1.0f,  0.0f}, {0.0f, 0.0f}},
    {{ 0.5f,  0.5f,  0.5f}, { 0.0f,  1.0f,  0.0f}, {1.0f, 1.0f}},
    {{ 0.5f,  0.5f,  0.5f}, { 0.0f,  1.0f,  0.0f}, {1.0f, 1.0f}},
    {{-0.5f,  0.5f, -0.5f}, { 0.0f,  1.0f,  0.0f}, {0.0f, 0.0f}},
    {{-0.5f,  0.5f,  0.5f}, { 0.0f,  1.0f,  0.0f}, {0.0f, 1.0f}},

    {{-0.5f,  0.5f, -0.5f}, {-1.0f,  0.0f,  0.0f}, {1.0f, 0.0f}},
    {{-0.5f, -0.5f, -0.5f}, {-1.0f,  0.0f,  0.0f}, {0.0f, 0.0f}},
    {{-0.5f,  0.5f,  0.5f}, {-1.0f,  0.0f,  0.0f}, {1.0f, 1.0f}},
    {{-0.5f,  0.5f,  0.5f}, {-1.0f,  0.0f,  0.0f}, {1.0f, 1.0f}},
    {{-0.5f, -0.5f, -0.5f}, {-1.0f,  0.0f,  0.0f}, {0.0f, 0.0f}},
    {{-0.5f, -0.5f,  0.5f}, {-1.0f,  0.0f,  0.0f}, {0.0f, 1.0f}},

    {{-0.5f, -0.5f, -0.5f}, { 0.0f, -1.0f,  0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, -0.5f}, { 0.0f, -1.0f,  0.0f}, {1.0f, 0.0f}},
    {{-0.5f, -0.5f,  0.5f}, { 0.0f, -1.0f,  0.0f}, {0.0f, 1.0f}},
    {{-0.5f, -0.5f,  0.5f}, { 0.0f, -1.0f,  0.0f}, {0.0f, 1.0f}},
    {{ 0.5f, -0.5f, -0.5f}, { 0.0f, -1.0f,  0.0f}, {1.0f, 0.0f}},
    {{ 0.5f, -0.5f,  0.5f}, { 0.0f, -1.0f,  0.0f}, {1.0f, 1.0f}},

    {{ 0.5f,  0.5f,  0.5f}, { 0.0f,  0.0f,  1.0f}, {1.0f, 1.0f}},
    {{-0.5f,  0.5f,  0.5f}, { 0.0f,  0.0f,  1.0f}, {0.0f, 1.0f}},
    {{ 0.5f, -0.5f,  0.5f}, { 0.0f,  0.0f,  1.0f}, {1.0f, 0.0f}},
    {{ 0.5f, -0.5f,  0.5f}, { 0.0f,  0.0f,  1.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f,  0.5f}, { 0.0f,  0.0f,  1.0f}, {0.0f, 1.0f}},
    {{-0.5f, -0.5f,  0.5f}, { 0.0f,  0.0f,  1.0f}, {0.0f, 0.0f}},

    {{ 0.5f, -0.5f, -0.5f}, { 0.0f,  0.0f, -1.0f}, {4.0f, 0.0f}},
    {{-0.5f, -0.5f, -0.5f}, { 0.0f,  0.0f, -1.0f}, {0.0f, 0.0f}},
    {{ 0.5f,  0.5f, -0.5f}, { 0.0f,  0.0f, -1.0f}, {4.0f, 4.0f}},
    {{ 0.5f,  0.5f, -0.5f}, { 0.0f,  0.0f, -1.0f}, {4.0f, 4.0f}},
    {{-0.5f, -0.5f, -0.5f}, { 0.0f,  0.0f, -1.0f}, {0.0f, 0.0f}},
    {{-0.5f,  0.5f, -0.5f}, { 0.0f,  0.0f, -1.0f}, {0.0f, 4.0f}},
};

enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_TEXTURE0_SAMPLER2D,
    UNIFORM_TEXTURE1_SAMPLER2D,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

@interface ViewController ()
{
    GLuint _program;

    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLfloat _rotation;
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@end
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [AGLKContext setCurrentContext:glkView.context];

    [self loadShader];

    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7, 0.7, 0.7, 1);

    glEnable(GL_DEPTH_TEST);

    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0.65, 0.65, 0.65, 1);

    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usage:GL_STATIC_DRAW];

    CGImageRef imageRef0 = [UIImage imageNamed:@"leaves2.gif"].CGImage;
    CGImageRef imageRef1 = [UIImage imageNamed:@"beetle"].CGImage;
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:NULL];

    self.baseEffect.texture2d0.name = textureInfo0.name;
    self.baseEffect.texture2d0.target = textureInfo0.target;

    self.baseEffect.texture2d1.name = textureInfo1.name;
    self.baseEffect.texture2d1.target = textureInfo1.target;
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;

    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S value:GL_REPEAT];
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_T value:GL_REPEAT];
    [self.baseEffect.texture2d1 aglkSetParameter:GL_TEXTURE_WRAP_S value:GL_REPEAT];
    [self.baseEffect.texture2d1 aglkSetParameter:GL_TEXTURE_WRAP_T value:GL_REPEAT];

   /*
    glBindTexture(self.baseEffect.texture2d0.target, self.baseEffect.texture2d0.name);
    glTexParameteri(self.baseEffect.texture2d0.target,GL_TEXTURE_WRAP_S,GL_REPEAT);
    glBindTexture(self.baseEffect.texture2d0.target, self.baseEffect.texture2d0.name);
    glTexParameteri(self.baseEffect.texture2d0.target,GL_TEXTURE_WRAP_T,GL_REPEAT);

    glBindTexture(self.baseEffect.texture2d1.target, self.baseEffect.texture2d1.name);
    glTexParameteri(self.baseEffect.texture2d1.target,GL_TEXTURE_WRAP_S,GL_REPEAT);
    glBindTexture(self.baseEffect.texture2d1.target, self.baseEffect.texture2d1.name);
    glTexParameteri(self.baseEffect.texture2d1.target,GL_TEXTURE_WRAP_T,GL_REPEAT);
*/
}

- (void)update
{
    float aspect = fabs(self.view.frame.size.width/self.view.frame.size.height);
    GLKMatrix4 projectionMartrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1, 100);

    self.baseEffect.transform.projectionMatrix = projectionMartrix;

    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0, 0, -4);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0, 1, 0);

    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0, 0, -1.5);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1, 1, 1);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);

    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;

    modelViewMatrix = GLKMatrix4MakeTranslation(0, 0, 1.5);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1, 1, 1);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);

    _normalMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(modelViewMatrix, NULL));
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMartrix, modelViewMatrix);

    _rotation += self.timeSinceLastUpdate*0.5;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];

    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, normalCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];

    [self.baseEffect prepareToDraw];

    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];

    glUseProgram(_program);

    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    glUniform1i(uniforms[UNIFORM_TEXTURE0_SAMPLER2D], 0);
    glUniform1i(uniforms[UNIFORM_TEXTURE1_SAMPLER2D], 1);

    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices)/sizeof(SceneVertex));
}

- (BOOL)loadShader
{
    GLuint vertShader,fragShader;
    NSString *vertShaderPathName = [[NSBundle mainBundle]pathForResource:@"Shader" ofType:@"vsh"];
    NSString *fragShaderPathName = [[NSBundle mainBundle]pathForResource:@"Shader" ofType:@"fsh"];

    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathName] ||
        ![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathName])
    {
        NSLog(@"Failed to compile vertex or fragment shader");
        return NO;
    }
    _program = glCreateProgram();

    glAttachShader(_program, vertShader);
    glAttachShader(_program, fragShader);

    glBindAttribLocation(_program, GLKVertexAttribPosition, "aPosition");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "aNormal");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "aTextureCoord0");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord1, "aTextureCoord1");

    if (![self linkProgram:_program])
    {
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program)
        {
            glDeleteShader(_program);
            _program = 0;
        }
        return NO;
    }

    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "uModelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "uNormalMatrix");
    uniforms[UNIFORM_TEXTURE0_SAMPLER2D] = glGetUniformLocation(_program, "uSampler0");
    uniforms[UNIFORM_TEXTURE0_SAMPLER2D] = glGetUniformLocation(_program, "uSampler1");

    if (vertShader)
    {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader)
    {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
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
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif

    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;

    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }

    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);

#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif

    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (void)dealloc
{
    self.vertexBuffer = nil;
    [AGLKContext setCurrentContext:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
