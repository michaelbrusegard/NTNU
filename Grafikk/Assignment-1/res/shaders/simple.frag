#version 430 core

in layout(location = 0) vec3 normal;
in layout(location = 1) vec2 textureCoordinates;
in layout(location = 2) vec3 fragmentPosition;

uniform vec3 lightPosition1;
uniform vec3 lightPosition2;
uniform vec3 lightPosition3;
uniform vec3 cameraPosition;
uniform vec3 ballPosition;

out vec4 color;

float rand(vec2 co) { return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453); }
float dither(vec2 uv) { return (rand(uv)*2.0-1.0) / 256.0; }

const float BALL_RADIUS = 3.0;

vec3 reject(vec3 from, vec3 onto) {
    return from - onto * dot(from, onto) / dot(onto, onto);
}

bool isInShadow(vec3 lightPos) {
    vec3 lightDir = lightPos - fragmentPosition;
    vec3 ballDir = ballPosition - fragmentPosition;

    float lightDist = length(lightDir);
    float ballDist = length(ballDir);
    if (lightDist < ballDist) return false;

    if (dot(normalize(lightDir), normalize(ballDir)) < 0.0) return false;

    vec3 rejection = reject(ballDir, normalize(lightDir));
    return length(rejection) < BALL_RADIUS;
}

void main() {
    vec3 N = normalize(normal);
    vec3 ambient = vec3(0.1);
    vec3 diffuseColor = vec3(0.3);
    vec3 specularColor = vec3(1.0);
    float shininess = 32.0;

    float la = 0.0002;
    float lb = 0.0002;
    float lc = 0.0002;

    vec3 diffuse = vec3(0.0);
    vec3 specular = vec3(0.0);
    vec3 viewDir = normalize(cameraPosition - fragmentPosition);

    // Light 1
    if (!isInShadow(lightPosition1)) {
        vec3 lightDir = normalize(lightPosition1 - fragmentPosition);
        float distance = length(lightPosition1 - fragmentPosition);
        float attenuation = 1.0 / (la + lb * distance + lc * distance * distance);

        float diff = max(dot(N, lightDir), 0.0);
        diffuse += diff * diffuseColor * attenuation;

        vec3 reflectDir = reflect(-lightDir, N);
        float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
        specular += spec * specularColor * attenuation;
    }

    // Light 2
    if (!isInShadow(lightPosition2)) {
        vec3 lightDir = normalize(lightPosition2 - fragmentPosition);
        float distance = length(lightPosition2 - fragmentPosition);
        float attenuation = 1.0 / (la + lb * distance + lc * distance * distance);

        float diff = max(dot(N, lightDir), 0.0);
        diffuse += diff * diffuseColor * attenuation;

        vec3 reflectDir = reflect(-lightDir, N);
        float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
        specular += spec * specularColor * attenuation;
    }

    // Light 3
    // if (!isInShadow(lightPosition3)) {
    //     vec3 lightDir = normalize(lightPosition3 - fragmentPosition);
    //     float distance = length(lightPosition3 - fragmentPosition);
    //     float attenuation = 1.0 / (la + lb * distance + lc * distance * distance);
    //
    //     float diff = max(dot(N, lightDir), 0.0);
    //     diffuse += diff * diffuseColor * attenuation;
    //
    //     vec3 reflectDir = reflect(-lightDir, N);
    //     float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    //     specular += spec * specularColor * attenuation;
    // }
    //
    color = vec4(ambient + diffuse + specular, 1.0) + vec4(dither(textureCoordinates), dither(textureCoordinates), dither(textureCoordinates), 0.0);
}
