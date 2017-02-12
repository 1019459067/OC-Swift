//
//  AGLKView.h
//  OpenGL_ES_02
//
//  Created by STMBP on 2017/2/4.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

typedef enum
{
    AGLKViewDrawableDepthFormatNone = 0,
    AGLKViewDrawableDepthFormat16,
}AGLKViewDrawableDepthFormat;

@protocol AGLKViewDelegate;
@class EAGLContext;
@interface AGLKView : UIView
{
//    EAGLContext *context;
    GLuint defaultFrameBuffer;
    GLuint colorRenderBuffer;
    GLuint depthRenderBuffer;
//    GLuint drawableWidth;
//    GLuint drawableHeight;
}
@property (weak, nonatomic) id<AGLKViewDelegate> delegate;
@property (strong, nonatomic) EAGLContext *context;
@property (nonatomic,readonly) GLint drawableWidth;
@property (nonatomic,readonly) GLint drawableHeight;
@property (nonatomic) AGLKViewDrawableDepthFormat drawableDepthFormat;

- (void)display;
@end

@protocol AGLKViewDelegate <NSObject>

@required
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end
