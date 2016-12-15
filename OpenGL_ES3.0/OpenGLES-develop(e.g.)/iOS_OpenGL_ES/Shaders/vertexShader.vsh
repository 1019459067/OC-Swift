attribute vec4 position;
attribute vec4 color;
attribute vec2 texture_coord;

varying lowp vec4 colorVarying;
varying lowp vec2 texture_uv;

uniform mat4 modelViewProjectionMatrix;

void main(void)
{
    gl_Position =modelViewProjectionMatrix *  position;
    colorVarying = color;
    texture_uv = texture_coord;
}