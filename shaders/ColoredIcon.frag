#version 460

layout(binding = 0) uniform sampler2D source;
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
	vec4 color;
};

void main()
{
    vec4 sampleColor = texture(source, qt_TexCoord0);
	if (sampleColor.r == sampleColor.b && sampleColor.g == sampleColor.b) fragColor = vec4(color.rgb * sampleColor.a, sampleColor.a) * qt_Opacity;
	else fragColor = vec4(sampleColor.rgba) * qt_Opacity;
}