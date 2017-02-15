//
//  AGLKTextureTransformBaseEffect.h
//  OpenGL_ES_15
//
//  Created by STMBP on 2017/2/14.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKTextureTransformBaseEffect : GLKBaseEffect

@property (nonatomic, assign) GLKVector4 light0Position;
@property (nonatomic, assign) GLKVector3 light0SpotDirection;
@property (nonatomic, assign) GLKVector4 light1Position;
@property (nonatomic, assign) GLKVector3 light1SpotDirection;
@property (nonatomic, assign) GLKVector4 light2Position;
@property (nonatomic, assign) GLKMatrix4 textureMatrix2d0;
@property (nonatomic, assign) GLKMatrix4 textureMatrix2d1;

- (void)prepareToDrawMultiTextures;
@end

@interface GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value;

@end
