varying lowp vec2 texture_uv;

varying lowp vec4 colorVarying;
uniform sampler2D mytextureSampler;

void main (void)
{
   
    gl_FragColor =colorVarying;//vec4(1.0,0.0,0.0,1.0);// colorVarying;
//    gl_FragColor = texture2D(mytextureSampler,texture_uv).rbga;;
}