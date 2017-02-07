//
//  AGLKTextureLoader.h
//  OpenGL_ES_05
//
//  Created by STMBP on 2017/2/6.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

/** 纹理缓存的相关信息 */
@interface AGLKTextureInfo : NSObject

@property(assign,nonatomic,readonly)GLuint name;
@property(assign,nonatomic,readonly)GLenum target;
@property(assign,nonatomic,readonly)GLenum width;
@property(assign,nonatomic,readonly)GLenum height;

@end


@interface AGLKTextureLoader : NSObject

+ (AGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage options:(NSDictionary*)options error:(NSError**)outError;

@end
