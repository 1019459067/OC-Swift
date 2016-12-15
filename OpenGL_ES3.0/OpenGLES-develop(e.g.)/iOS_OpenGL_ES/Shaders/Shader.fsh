//
//  Shader.fsh
//  iOS_OPenGL_ES
//
//  Created by Yuanfei He on 16/4/12.
//  Copyright © 2016年 Yuanfei He. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
