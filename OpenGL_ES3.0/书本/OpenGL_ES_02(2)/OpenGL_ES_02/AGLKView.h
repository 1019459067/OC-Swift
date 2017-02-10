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

@protocol AGLKViewDelegate;
@class EAGLContext;
@interface AGLKView : UIView
{
//    EAGLContext *context;
    GLuint defaultFrameBuffer;
    GLuint colorRenderBuffer;
//    GLuint drawableWidth;
//    GLuint drawableHeight;
}
@property (weak, nonatomic) id<AGLKViewDelegate> delegate;
@property (strong, nonatomic) EAGLContext *context;
@property (nonatomic,readonly) NSInteger drawableWidth;
@property (nonatomic,readonly) NSInteger drawableHeight;

- (void)display;
@end

@protocol AGLKViewDelegate <NSObject>

@required
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end
