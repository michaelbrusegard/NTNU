#version 430 core

struct Light {
    vec3 position;
    vec3 color;
};

in layout(location = 0) vec3 normal;
in layout(location = 1) vec2 textureCoordinates;
in layout(location = 2) vec3 fragmentPosition;

uniform vec3 cameraPosition;
uniform vec3 ballPosition;
uniform Light lights[4];

out vec4 color;

float rand(vec2 co) { return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453); }
float dither(vec2 uv) { return (rand(uv)*2.0-1.0) / 256.0; }

const float BALL_RADIUS = 3.0;
const float SOFT_RADIUS = 6.0;

vec3 reject(vec3 from, vec3 onto) {
    return from - onto * dot(from, onto) / dot(onto, onto);
}

float getShadowFactor(vec3 lightPos) {
    vec3 lightDir = lightPos - fragmentPosition;
    vec3 ballDir = ballPosition - fragmentPosition;

    float lightDist = length(lightDir);
    float ballDist = length(ballDir);
    if (lightDist < ballDist) return 1.0;

    if (dot(normalize(lightDir), normalize(ballDir)) < 0.0) return 1.0;

    vec3 rejection = reject(ballDir, normalize(lightDir));
    float rejectionLength = length(rejection);

    if (rejectionLength < BALL_RADIUS) return 0.0;

    if (rejectionLength < SOFT_RADIUS) {
        return smoothstep(BALL_RADIUS, SOFT_RADIUS, rejectionLength);
    }

    return 1.0;
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
    float shininess = 8.0;

    float la = 0.0002;
    float lb = 0.0002;
    float lc = 0.0002;

    vec3 diffuse = vec3(0.0);
    vec3 specular = vec3(0.0);
    vec3 viewDir = normalize(cameraPosition - fragmentPosition);

for(int i = 0; i < 3; i++) {
        float shadowFactor = getShadowFactor(lights[i].position);
        if (shadowFactor > 0.0) {
            vec3 lightDir = normalize(lights[i].position - fragmentPosition);
            float distance = length(lights[i].position - fragmentPosition);
            float attenuation = 1.0 / (la + lb * distance + lc * distance * distance);

            float diff = max(dot(N, lightDir), 0.0);
            diffuse += diff * diffuseColor * attenuation * lights[i].color * shadowFactor;

            vec3 reflectDir = reflect(-lightDir, N);
            float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
            specular += spec * specularColor * attenuation * lights[i].color * shadowFactor;
        }
    }


    color = vec4(ambient + diffuse + specular, 1.0) + 
            vec4(dither(textureCoordinates), dither(textureCoordinates), dither(textureCoordinates), 0.0);
}
