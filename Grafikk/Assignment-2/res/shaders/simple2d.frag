#version 430 core

in layout(location = 2) vec2 textureCoordinates_in;
layout(binding = 0) uniform sampler2D textureSample;

out vec4 color;

void main() {
    color = texture(textureSample, textureCoordinates_in);
}
