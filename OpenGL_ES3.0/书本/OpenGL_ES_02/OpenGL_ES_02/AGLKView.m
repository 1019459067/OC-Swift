//
//  AGLKView.m
//  OpenGL_ES_02
//
//  Created by STMBP on 2017/2/4.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "AGLKView.h"

@implementation AGLKView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}
- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext
{
    if (self = [super initWithFrame:frame])
    {
        [self initContext];
        self.context = aContext;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initContext];
    }
    return self;
}
- (void)initContext
{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setContext:(EAGLContext *)context
{
    if (self.context != context)
    {
        [EAGLContext setCurrentContext:self.context];

        if (0 != defaultFrameBuffer)
        {
            glDeleteRenderbuffers(1, &defaultFrameBuffer);
            defaultFrameBuffer = 0;
        }
        if (0 != colorRenderBuffer)
        {
            glDeleteRenderbuffers(1, &colorRenderBuffer);
            colorRenderBuffer = 0;
        }

        self.context = context;

        if (self.context != nil)
        {
            self.context = context;
            [EAGLContext setCurrentContext:self.context];

            glGenFramebuffers(1, &defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);

            glGenRenderbuffers(1, &colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);

            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
        }
    }
}
- (EAGLContext *)context
{
    return self.context;
}
- (void)display
{
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, (GLsizei)self.drawableWidth, (GLsizei)self.drawableHeight);

    [self drawRect:self.bounds];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}
- (void)drawRect:(CGRect)rect
{
    if ([self.delegate respondsToSelector:@selector(glkView:drawInRect:)])
    {
        [self.delegate glkView:self drawInRect:rect];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];

    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);

    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"failed to make buffer %d",status);
    }
}

- (NSInteger)drawableWidth
{
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return backingWidth;
}
- (NSInteger)drawableHeight
{
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return backingHeight;
}
- (void)dealloc
{
    if ([EAGLContext currentContext] == self.context)
    {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}
@end
