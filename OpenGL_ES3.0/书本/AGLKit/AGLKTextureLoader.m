//
//  AGLKTextureLoader.m
//  OpenGL_ES_05
//
//  Created by STMBP on 2017/2/6.
//  Copyright © 2017年 sensetime. All rights reserved.
//

#import "AGLKTextureLoader.h"

@implementation AGLKTextureInfo
@synthesize name,target,width,height;

- (instancetype)initWithName:(GLuint)aName target:(GLenum)aTarget width:(GLuint)aWidth height:(GLuint)aHeight
{
    if (self = [super init])
    {
        name = aName;
        target = aTarget;
        width = aWidth;
        height = aHeight;
    }
    return self;
}
@end

typedef enum
{
    AGLK1 = 1,
    AGLK2 = 2,
    AGLK4 = 4,
    AGLK8 = 8,
    AGLK16 = 16,
    AGLK32 = 32,
    AGLK64 = 64,
    AGLK128 = 128,
    AGLK256 = 256,
    AGLK512 = 512,
    AGLK1024 = 1024,
}
AGLKPowerOf2;

/**
 获取用于初始化纹理缓存的内容的字节

 @param cgImage 纹理缓存的内容
 @param widthPtr 纹理缓存的内容的宽
 @param heightPtr 纹理缓存的内容的高
 @return NSData
 */
static NSData *AGLKDataWithResizedCGImageBytes(CGImageRef cgImage,size_t *widthPtr,size_t *heightPtr);

/**
 重新计算纹理缓存的尺寸

 @param dimension 纹理缓存的尺寸
 @return AGLKPowerOf2类型
 */
static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension(GLuint dimension);

@implementation AGLKTextureLoader

+ (AGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage options:(NSDictionary *)options error:(NSError *__autoreleasing *)outError
{
    size_t width;
    size_t height;
    NSData *imageData = AGLKDataWithResizedCGImageBytes(cgImage, &width, &height);

    GLuint textureBufferID;

    glGenTextures(1, &textureBufferID);
    glBindTexture(GL_TEXTURE_2D, textureBufferID);
        ///复制图片像素的颜色数据到绑定的纹理缓存中
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLint)width, (GLint)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, [imageData bytes]);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

    AGLKTextureInfo *result = [[AGLKTextureInfo alloc]initWithName:textureBufferID target:GL_TEXTURE_2D width:(GLuint)width height:(GLuint)height];
    return result;
}

@end

static NSData *AGLKDataWithResizedCGImageBytes(CGImageRef cgImage,size_t *widthPtr,size_t *heightPtr)
{
    NSCParameterAssert(NULL != cgImage);
    NSCParameterAssert(NULL != widthPtr);
    NSCParameterAssert(NULL != heightPtr);

    GLuint originalWidth = (GLuint)CGImageGetWidth(cgImage);
    GLuint originalHeight = (GLuint)CGImageGetHeight(cgImage);

    GLuint width = AGLKCalculatePowerOf2ForDimension(originalWidth);
    GLuint height = AGLKCalculatePowerOf2ForDimension(originalHeight);

    NSMutableData *imageData = [NSMutableData dataWithLength:height * width * 4];
    NSCAssert(imageData != nil, @"Unable to allocate image storage");

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes], width, height, 8, width * 4, colorSpace, kCGImageAlphaNoneSkipLast);
    CGColorSpaceRelease(colorSpace);

    CGContextTranslateCTM(cgContext, 0, height);
    CGContextScaleCTM(cgContext, 1, -1);

    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(cgContext);

    *widthPtr = width;
    *heightPtr = height;
    return imageData;
}

static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension(GLuint dimension)
{
    AGLKPowerOf2  result = AGLK1;

    if(dimension > (GLuint)AGLK512)
    {
        result = AGLK1024;
    }
    else if(dimension > (GLuint)AGLK256)
    {
        result = AGLK512;
    }
    else if(dimension > (GLuint)AGLK128)
    {
        result = AGLK256;
    }
    else if(dimension > (GLuint)AGLK64)
    {
        result = AGLK128;
    }
    else if(dimension > (GLuint)AGLK32)
    {
        result = AGLK64;
    }
    else if(dimension > (GLuint)AGLK16)
    {
        result = AGLK32;
    }
    else if(dimension > (GLuint)AGLK8)
    {
        result = AGLK16;
    }
    else if(dimension > (GLuint)AGLK4)
    {
        result = AGLK8;
    }
    else if(dimension > (GLuint)AGLK2)
    {
        result = AGLK4;
    }
    else if(dimension > (GLuint)AGLK1)
    {
        result = AGLK2;
    }
    return result;
}
