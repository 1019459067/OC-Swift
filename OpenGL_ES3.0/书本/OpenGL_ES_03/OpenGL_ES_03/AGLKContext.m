//
//  AGLKContext.m
//  OpenGL_ES_03
//
//  Created by 肖伟华 on 2017/2/5.
//  Copyright © 2017年 XWH. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext
- (void)setClearColor:(GLKVector4)clearColor
{
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}
- (GLKVector4)clearColor
{
    return self.clearColor;
}
- (void)clear:(GLbitfield)mask
{
    glClear(mask);
}
@end
