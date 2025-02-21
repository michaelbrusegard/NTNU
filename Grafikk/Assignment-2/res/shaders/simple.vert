#version 430 core

in layout(location = 0) vec3 position;
in layout(location = 1) vec3 normal_in;
in layout(location = 2) vec2 textureCoordinates_in;

uniform layout(location = 3) mat4 MVP;
uniform mat4 modelMatrix;
uniform mat3 normalMatrix;
uniform layout(location = 4) vec3 tangents;
uniform layout(location = 5) vec3 bitangents;

out layout(location = 0) vec3 normal_out;
out layout(location = 1) vec2 textureCoordinates_out;
out layout(location = 2) vec3 fragmentPosition;

out layout(location = 3) mat3 TBN;

void main() {
    vec3 normal = normalize(normalMatrix * normal_in);
    vec3 tangent = normalize(normalMatrix * tangents);
    vec3 bitangent = normalize(normalMatrix * bitangents);

    TBN = mat3(normalize(tangent), normalize(bitangent), normalize(normal));

    // Transform normal with normal matrix and normalize
    normal_out = normalize(normalMatrix * normal_in);

    // Transforming vertex position for lighting calculations
    fragmentPosition = vec3(modelMatrix * vec4(position, 1.0));
    textureCoordinates_out = textureCoordinates_in;
    gl_Position = MVP * vec4(position, 1.0);
}
