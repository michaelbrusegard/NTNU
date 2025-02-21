#version 430 core

in layout(location = 0) vec3 position;
in layout(location = 2) vec2 textureCoordinates_in;

uniform layout(location = 3) mat4 MVP;
uniform mat4 ortho;

out layout(location = 2) vec2 textureCoordinates_out;

void main() {
    textureCoordinates_out = textureCoordinates_in;
    gl_Position = ortho * MVP * vec4(position, 1.0);
}
