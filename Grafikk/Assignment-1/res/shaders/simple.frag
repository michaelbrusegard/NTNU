#version 430 core

in layout(location = 0) vec3 normal;
in layout(location = 1) vec2 textureCoordinates;
in layout(location = 2) vec3 fragmentPosition;

uniform vec3 lightPosition1;
uniform vec3 lightPosition2;
uniform vec3 lightPosition3;

out vec4 color;

void main() {
    vec3 N = normalize(normal);
    vec3 ambient = vec3(0.02);
    vec3 diffuseColor = vec3(0.2);
    vec3 diffuse = vec3(0.0);
    vec3 lightDir;
    float diff;
    
    // Light 1
    lightDir = normalize(lightPosition1 - fragmentPosition);
    diff = max(dot(N, lightDir), 0.0);
    diffuse += diff * diffuseColor;
    
    // Light 2
    lightDir = normalize(lightPosition2 - fragmentPosition);
    diff = max(dot(N, lightDir), 0.0);
    diffuse += diff * diffuseColor;
    
    // Light 3
    lightDir = normalize(lightPosition3 - fragmentPosition);
    diff = max(dot(N, lightDir), 0.0);
    diffuse += diff * diffuseColor;
    
    color = vec4(ambient + diffuse, 1.0);
}
