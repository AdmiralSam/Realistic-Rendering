#version 330 core
#define TextureSize 1024
#define BumpStrength 3.0

in vec3 position;
in vec2 uv;
in vec3 normal;
in vec3 tangent;
in vec3 bitangent;

layout (location = 0) out vec3 diffuseColor;
layout (location = 1) out vec3 specularColor;
layout (location = 2) out vec3 positionColor;
layout (location = 3) out vec3 normalColor;

uniform sampler2D texture_diffuse1;
uniform sampler2D texture_normal1;
uniform sampler2D texture_specular1;
uniform sampler2D texture_mask1;

void main()
{
    if (texture(texture_mask1, uv).r < 0.5)
    {
        discard;
    }
    diffuseColor = texture(texture_diffuse1, uv).rgb;
    specularColor = texture(texture_specular1, uv).rgb;
    positionColor = position;

    float du = texture(texture_normal1, uv + vec2(1.0 / TextureSize, 0.0)).r - texture(texture_normal1, uv - vec2(1.0 / TextureSize, 0.0)).r;
    float dv = texture(texture_normal1, uv + vec2(0.0, 1.0 / TextureSize)).r - texture(texture_normal1, uv - vec2(0.0, 1.0 / TextureSize)).r;
    vec3 modifiedTangent = normalize(tangent) + BumpStrength * du * normalize(normal);
    vec3 modifiedBitangent = normalize(bitangent) + BumpStrength * dv * normalize(normal);
    vec3 potentialNormal = normalize(cross(modifiedTangent, modifiedBitangent));
    if (dot(potentialNormal, normal) < 0.0)
    {
        normalColor = -potentialNormal;
    }
    else
    {
        normalColor = potentialNormal;
    }
}