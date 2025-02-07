#version 430 core

in layout(location = 0) vec3 normal;
in layout(location = 1) vec2 textureCoordinates;
in layout(location = 2) vec3 fragmentPosition;

uniform vec3 lightPosition1;
uniform vec3 lightPosition2;
uniform vec3 lightPosition3;
uniform vec3 cameraPosition;

out vec4 color;

void main() {
    vec3 N = normalize(normal);
    vec3 ambient = vec3(0.02);
    vec3 diffuseColor = vec3(0.2);
    vec3 specularColor = vec3(1.0);
    float shininess = 32.0;

    vec3 diffuse = vec3(0.0);
    vec3 specular = vec3(0.0);
    vec3 viewDir = normalize(cameraPosition - fragmentPosition);
    vec3 lightDir;
    vec3 reflectDir;
    float diff;
    float spec;

    // Light 1
    lightDir = normalize(lightPosition1 - fragmentPosition);
    diff = max(dot(N, lightDir), 0.0);
    diffuse += diff * diffuseColor;

    reflectDir = reflect(-lightDir, N);
    spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    specular += spec * specularColor;

    // Light 2
    lightDir = normalize(lightPosition2 - fragmentPosition);
    diff = max(dot(N, lightDir), 0.0);
    diffuse += diff * diffuseColor;

    reflectDir = reflect(-lightDir, N);
    spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    specular += spec * specularColor;

    // Light 3
    lightDir = normalize(lightPosition3 - fragmentPosition);
    diff = max(dot(N, lightDir), 0.0);
    diffuse += diff * diffuseColor;

    reflectDir = reflect(-lightDir, N);
    spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    specular += spec * specularColor;

    color = vec4(ambient + diffuse + specular, 1.0);
}
