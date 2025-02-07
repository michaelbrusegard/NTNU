#version 430 core

in layout(location = 0) vec3 position;
in layout(location = 1) vec3 normal_in;
in layout(location = 2) vec2 textureCoordinates_in;

uniform layout(location = 3) mat4 MVP;
uniform layout(location = 4) mat4 modelMatrix;
uniform layout(location = 5) mat3 normalMatrix;

out layout(location = 0) vec3 normal_out;
out layout(location = 1) vec2 textureCoordinates_out;
out layout(location = 2) vec3 fragmentPosition;

void main() {
    // Transform normal with normal matrix and normalize
    normal_out = normalize(normalMatrix * normal_in);

    // Transforming vertex position for lighting calculations
    fragmentPosition = vec3(modelMatrix * vec4(position, 1.0));
    textureCoordinates_out = textureCoordinates_in;
    gl_Position = MVP * vec4(position, 1.0);
}
