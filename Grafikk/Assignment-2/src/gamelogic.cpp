#include <chrono>
#include <GLFW/glfw3.h>
#include <glad/glad.h>
#include <SFML/Audio/SoundBuffer.hpp>
#include <utilities/shader.hpp>
#include <glm/vec3.hpp>
#include <iostream>
#include <utilities/timeutils.h>
#include <utilities/mesh.h>
#include <utilities/shapes.h>
#include <utilities/glutils.h>
#include <SFML/Audio/Sound.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <fmt/format.h>
#include "gamelogic.h"
#include "sceneGraph.hpp"
#define GLM_ENABLE_EXPERIMENTAL
#include <glm/gtx/transform.hpp>

#include "utilities/imageLoader.hpp"
#include "utilities/glfont.h"

enum KeyFrameAction {
    BOTTOM, TOP
};

#include <timestamps.h>

double padPositionX = 0;
double padPositionZ = 0;

unsigned int currentKeyFrame = 0;
unsigned int previousKeyFrame = 0;

SceneNode* rootNode;
SceneNode* rootNode2d;
SceneNode* boxNode;
SceneNode* ballNode;
SceneNode* padNode;
SceneNode* lightNode1;
SceneNode* lightNode2;
SceneNode* lightNode3;
SceneNode* movingLightNode;
SceneNode* textNode;

double ballRadius = 3.0f;

glm::mat4 orthoVP;

// These are heap allocated, because they should not be initialised at the start of the program
sf::SoundBuffer* buffer;
Gloom::Shader* shader;
Gloom::Shader* shader2d;
sf::Sound* sound;

const glm::vec3 boxDimensions(180, 90, 90);
const glm::vec3 padDimensions(30, 3, 40);

glm::vec3 ballPosition(0, ballRadius + padDimensions.y, boxDimensions.z / 2);
glm::vec3 ballDirection(1, 1, 0.2f);

CommandLineOptions options;

bool hasStarted        = false;
bool hasLost           = false;
bool jumpedToNextFrame = false;
bool isPaused          = false;

bool mouseLeftPressed   = false;
bool mouseLeftReleased  = false;
bool mouseRightPressed  = false;
bool mouseRightReleased = false;

// Modify if you want the music to start further on in the track. Measured in seconds.
const float debug_startTime = 0;
double totalElapsedTime = debug_startTime;
double gameElapsedTime = debug_startTime;

double mouseSensitivity = 1.0;
double lastMouseX = windowWidth / 2;
double lastMouseY = windowHeight / 2;
void mouseCallback(GLFWwindow* window, double x, double y) {
    int windowWidth, windowHeight;
    glfwGetWindowSize(window, &windowWidth, &windowHeight);
    glViewport(0, 0, windowWidth, windowHeight);

    double deltaX = x - lastMouseX;
    double deltaY = y - lastMouseY;

    padPositionX -= mouseSensitivity * deltaX / windowWidth;
    padPositionZ -= mouseSensitivity * deltaY / windowHeight;

    if (padPositionX > 1) padPositionX = 1;
    if (padPositionX < 0) padPositionX = 0;
    if (padPositionZ > 1) padPositionZ = 1;
    if (padPositionZ < 0) padPositionZ = 0;

    glfwSetCursorPos(window, windowWidth / 2, windowHeight / 2);
}

GLuint charmapTexture;
GLuint brickTexture;
GLuint brickNormalTexture;
GLuint brickRoughnessTexture;

// Function which takes in an image loaded into memory
GLuint createTextureFromImage(const PNGImage& image) {
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);

    // Texture parameters
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image.width, image.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image.pixels.data());
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    // Mipmap
    glGenerateMipmap(GL_TEXTURE_2D);
    return textureID;
}

void initGame(GLFWwindow* window, CommandLineOptions gameOptions) {
    orthoVP = glm::ortho(0.0f, (float) windowWidth, 0.0f, (float) windowHeight, -1.0f, 1.0f);

    buffer = new sf::SoundBuffer();
    if (!buffer->loadFromFile("../res/Hall of the Mountain King.ogg")) {
        return;
    }

    options = gameOptions;

    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_HIDDEN);
    glfwSetCursorPosCallback(window, mouseCallback);

    shader = new Gloom::Shader();
    shader->makeBasicShader("../res/shaders/simple.vert", "../res/shaders/simple.frag");
    shader->activate();

    shader2d = new Gloom::Shader();
    shader2d->makeBasicShader("../res/shaders/simple2d.vert", "../res/shaders/simple2d.frag");

    PNGImage charmap = loadPNGFile("../res/textures/charmap.png");
    charmapTexture = createTextureFromImage(charmap);

    PNGImage brick = loadPNGFile("../res/textures/Brick03_col.png");
    brickTexture = createTextureFromImage(brick);
    PNGImage brickNormal = loadPNGFile("../res/textures/Brick03_nrm.png");
    brickNormalTexture = createTextureFromImage(brickNormal);
    PNGImage brickRoughness = loadPNGFile("../res/textures/Brick03_rgh.png");
    brickRoughnessTexture = createTextureFromImage(brickRoughness);

    std::string text = "START GAME";
    float charRatio = 39.0f / 29.0f;
    float totalTextWidth = text.length() * 29.0f;
    Mesh textMesh = generateTextGeometryBuffer(text, charRatio, totalTextWidth);
    unsigned int textVAO = generateBuffer(textMesh);

    // Create meshes
    Mesh pad = cube(padDimensions, glm::vec2(30, 40), true);
    Mesh box = cube(boxDimensions, glm::vec2(90), true, true);
    Mesh sphere = generateSphere(1.0, 40, 40);

    // Fill buffers
    unsigned int ballVAO = generateBuffer(sphere);
    unsigned int boxVAO  = generateBuffer(box);
    unsigned int padVAO  = generateBuffer(pad);

    // Construct scene
    rootNode = createSceneNode();
    rootNode2d = createSceneNode();
    boxNode  = createSceneNode();
    padNode  = createSceneNode();
    ballNode = createSceneNode();

    rootNode->children.push_back(boxNode);
    rootNode->children.push_back(padNode);
    rootNode->children.push_back(ballNode);

    boxNode->vertexArrayObjectID  = boxVAO;
    boxNode->VAOIndexCount        = box.indices.size();
    boxNode->nodeType = NORMAL_MAPPED;
    boxNode->textureID = brickTexture;
    boxNode->normalMapID = brickNormalTexture;
    boxNode->roughnesstextureID = brickRoughnessTexture;

    padNode->vertexArrayObjectID  = padVAO;
    padNode->VAOIndexCount        = pad.indices.size();

    ballNode->vertexArrayObjectID = ballVAO;
    ballNode->VAOIndexCount       = sphere.indices.size();

    // Create text node
    SceneNode* textNode = createSceneNode();
    textNode->nodeType = GEOMETRY_2D;
    textNode->vertexArrayObjectID = textVAO;
    textNode->VAOIndexCount = textMesh.indices.size();
    textNode->textureID = charmapTexture;
    textNode->position = glm::vec3((windowWidth - totalTextWidth) / 2, (windowHeight - 29.0f) / 2, 0.0f);
    rootNode2d->children.push_back(textNode);

    // here I am creating the lights
    lightNode1 = createSceneNode();
    lightNode1->nodeType = POINT_LIGHT;
    lightNode1->position = glm::vec3(-25.0f, -40.0f, -75.0f);
    rootNode->children.push_back(lightNode1);

    lightNode2 = createSceneNode();
    lightNode2->nodeType = POINT_LIGHT;
    lightNode2->position = glm::vec3(0.0f, -40.0f, -75.0f);
    rootNode->children.push_back(lightNode2);

    lightNode3 = createSceneNode();
    lightNode3->nodeType = POINT_LIGHT;
    lightNode3->position = glm::vec3(25.0f, -40.0f, -75.0f);
    rootNode->children.push_back(lightNode3);

    // Moving light I am adding it as a child to the pad
    movingLightNode = createSceneNode();
    movingLightNode->nodeType = POINT_LIGHT;
    addChild(padNode, movingLightNode);

    getTimeDeltaSeconds();

    std::cout << fmt::format("Initialized scene with {} SceneNodes.", totalChildren(rootNode)) << std::endl;

    std::cout << "Ready. Click to start!" << std::endl;
}

void updateFrame(GLFWwindow* window) {
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);

    double timeDelta = getTimeDeltaSeconds();

    const float ballBottomY = boxNode->position.y - (boxDimensions.y/2) + ballRadius + padDimensions.y;
    const float ballTopY    = boxNode->position.y + (boxDimensions.y/2) - ballRadius;
    const float BallVerticalTravelDistance = ballTopY - ballBottomY;

    const float cameraWallOffset = 30; // Arbitrary addition to prevent ball from going too much into camera

    const float ballMinX = boxNode->position.x - (boxDimensions.x/2) + ballRadius;
    const float ballMaxX = boxNode->position.x + (boxDimensions.x/2) - ballRadius;
    const float ballMinZ = boxNode->position.z - (boxDimensions.z/2) + ballRadius;
    const float ballMaxZ = boxNode->position.z + (boxDimensions.z/2) - ballRadius - cameraWallOffset;

    if (glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_1)) {
        mouseLeftPressed = true;
        mouseLeftReleased = false;
    } else {
        mouseLeftReleased = mouseLeftPressed;
        mouseLeftPressed = false;
    }
    if (glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_2)) {
        mouseRightPressed = true;
        mouseRightReleased = false;
    } else {
        mouseRightReleased = mouseRightPressed;
        mouseRightPressed = false;
    }

    if(!hasStarted) {
        if (mouseLeftPressed) {
            if (options.enableMusic) {
                sound = new sf::Sound();
                sound->setBuffer(*buffer);
                sf::Time startTime = sf::seconds(debug_startTime);
                sound->setPlayingOffset(startTime);
                sound->play();
            }
            totalElapsedTime = debug_startTime;
            gameElapsedTime = debug_startTime;
            hasStarted = true;
        }

        ballPosition.x = ballMinX + (1 - padPositionX) * (ballMaxX - ballMinX);
        ballPosition.y = ballBottomY;
        ballPosition.z = ballMinZ + (1 - padPositionZ) * ((ballMaxZ+cameraWallOffset) - ballMinZ);
    } else {
        totalElapsedTime += timeDelta;
        if(hasLost) {
            if (mouseLeftReleased) {
                hasLost = false;
                hasStarted = false;
                currentKeyFrame = 0;
                previousKeyFrame = 0;
            }
        } else if (isPaused) {
            if (mouseRightReleased) {
                isPaused = false;
                if (options.enableMusic) {
                    sound->play();
                }
            }
        } else {
            gameElapsedTime += timeDelta;
            if (mouseRightReleased) {
                isPaused = true;
                if (options.enableMusic) {
                    sound->pause();
}
            }
            // Get the timing for the beat of the song
            for (unsigned int i = currentKeyFrame; i < keyFrameTimeStamps.size(); i++) {
                if (gameElapsedTime < keyFrameTimeStamps.at(i)) {
                    continue;
                }
                currentKeyFrame = i;
            }

            jumpedToNextFrame = currentKeyFrame != previousKeyFrame;
            previousKeyFrame = currentKeyFrame;

            double frameStart = keyFrameTimeStamps.at(currentKeyFrame);
            double frameEnd = keyFrameTimeStamps.at(currentKeyFrame + 1); // Assumes last keyframe at infinity

            double elapsedTimeInFrame = gameElapsedTime - frameStart;
            double frameDuration = frameEnd - frameStart;
            double fractionFrameComplete = elapsedTimeInFrame / frameDuration;

            double ballYCoord;

            KeyFrameAction currentOrigin = keyFrameDirections.at(currentKeyFrame);
            KeyFrameAction currentDestination = keyFrameDirections.at(currentKeyFrame + 1);

            // Synchronize ball with music
            if (currentOrigin == BOTTOM && currentDestination == BOTTOM) {
                ballYCoord = ballBottomY;
            } else if (currentOrigin == TOP && currentDestination == TOP) {
                ballYCoord = ballBottomY + BallVerticalTravelDistance;
            } else if (currentDestination == BOTTOM) {
                ballYCoord = ballBottomY + BallVerticalTravelDistance * (1 - fractionFrameComplete);
            } else if (currentDestination == TOP) {
                ballYCoord = ballBottomY + BallVerticalTravelDistance * fractionFrameComplete;
            }

            // Make ball move
            const float ballSpeed = 60.0f;
            ballPosition.x += timeDelta * ballSpeed * ballDirection.x;
            ballPosition.y = ballYCoord;
            ballPosition.z += timeDelta * ballSpeed * ballDirection.z;

            // Make ball bounce
            if (ballPosition.x < ballMinX) {
                ballPosition.x = ballMinX;
                ballDirection.x *= -1;
            } else if (ballPosition.x > ballMaxX) {
                ballPosition.x = ballMaxX;
                ballDirection.x *= -1;
            }
            if (ballPosition.z < ballMinZ) {
                ballPosition.z = ballMinZ;
                ballDirection.z *= -1;
            } else if (ballPosition.z > ballMaxZ) {
                ballPosition.z = ballMaxZ;
                ballDirection.z *= -1;
            }

            if(options.enableAutoplay) {
                padPositionX = 1-(ballPosition.x - ballMinX) / (ballMaxX - ballMinX);
                padPositionZ = 1-(ballPosition.z - ballMinZ) / ((ballMaxZ+cameraWallOffset) - ballMinZ);
            }

            // Check if the ball is hitting the pad when the ball is at the bottom.
            // If not, you just lost the game! (hehe)
            if (jumpedToNextFrame && currentOrigin == BOTTOM && currentDestination == TOP) {
                double padLeftX  = boxNode->position.x - (boxDimensions.x/2) + (1 - padPositionX) * (boxDimensions.x - padDimensions.x);
                double padRightX = padLeftX + padDimensions.x;
                double padFrontZ = boxNode->position.z - (boxDimensions.z/2) + (1 - padPositionZ) * (boxDimensions.z - padDimensions.z);
                double padBackZ  = padFrontZ + padDimensions.z;

                if (   ballPosition.x < padLeftX
                    || ballPosition.x > padRightX
                    || ballPosition.z < padFrontZ
                    || ballPosition.z > padBackZ
                ) {
                    hasLost = true;
                    if (options.enableMusic) {
                        sound->stop();
                        delete sound;
                    }
                }
            }
        }
    }

    glm::mat4 projection = glm::perspective(glm::radians(80.0f), float(windowWidth) / float(windowHeight), 0.1f, 350.f);

    glm::vec3 cameraPosition = glm::vec3(0, 2, -20);

    // Some math to make the camera move in a nice way
    float lookRotation = -0.6 / (1 + exp(-5 * (padPositionX-0.5))) + 0.3;
    glm::mat4 cameraTransform =
                    glm::rotate(0.3f + 0.2f * float(-padPositionZ*padPositionZ), glm::vec3(1, 0, 0)) *
                    glm::rotate(lookRotation, glm::vec3(0, 1, 0)) *
                    glm::translate(-cameraPosition);

    glm::mat4 VP = projection * cameraTransform;

    // Move and rotate various SceneNodes
    boxNode->position = { 0, -10, -80 };

    ballNode->position = ballPosition;
    ballNode->scale = glm::vec3(ballRadius);
    ballNode->rotation = { 0, totalElapsedTime*2, 0 };

    padNode->position  = {
        boxNode->position.x - (boxDimensions.x/2) + (padDimensions.x/2) + (1 - padPositionX) * (boxDimensions.x - padDimensions.x),
        boxNode->position.y - (boxDimensions.y/2) + (padDimensions.y/2),
        boxNode->position.z - (boxDimensions.z/2) + (padDimensions.z/2) + (1 - padPositionZ) * (boxDimensions.z - padDimensions.z)
    };

    // ballposition
    glm::vec3 ballPosition(0, ballRadius + padDimensions.y, boxDimensions.z / 2);

    SceneNode* movingLightNode = padNode->children[0];
    movingLightNode->position = padNode->position + glm::vec3(0.0f, 0.0f, 10.0f);

    updateNodeTransformations(rootNode, VP);
    updateNodeTransformations(rootNode2d, glm::mat4(1.0f));
}

void updateNodeTransformations(SceneNode* node, glm::mat4 transformationThusFar) {
    glm::mat4 transformationMatrix =
              glm::translate(node->position)
            * glm::translate(node->referencePoint)
            * glm::rotate(node->rotation.y, glm::vec3(0,1,0))
            * glm::rotate(node->rotation.x, glm::vec3(1,0,0))
            * glm::rotate(node->rotation.z, glm::vec3(0,0,1))
            * glm::scale(node->scale)
            * glm::translate(-node->referencePoint);

    // Here I store model matrix for transforming vertices
    node->modelMatrix = transformationMatrix;
    node->currentTransformationMatrix = transformationThusFar * transformationMatrix;

    // Here I compute the light positions
    if(node->nodeType == POINT_LIGHT) {
        // Transform light position from local to world space
        glm::vec4 lightPos = node->modelMatrix * glm::vec4(0.0f, 0.0f, 0.0f, 1.0f);
        node->position = glm::vec3(lightPos);
    }

    // store ball position
    ballNode->position = ballPosition;

    switch(node->nodeType) {
        case GEOMETRY: break;
        case POINT_LIGHT: break;
        case SPOT_LIGHT: break;
    }

    for(SceneNode* child : node->children) {
        updateNodeTransformations(child, node->currentTransformationMatrix);
    }
}

void setup3Duniforms() {
    // red light
    glUniform3fv(shader->getUniformFromName("lights[0].position"), 1, glm::value_ptr(lightNode1->position));
    glUniform3fv(shader->getUniformFromName("lights[0].color"), 1, glm::value_ptr(glm::vec3(1.0f, 0.0f, 0.0f)));

    // green light
    glUniform3fv(shader->getUniformFromName("lights[1].position"), 1, glm::value_ptr(lightNode2->position));
    glUniform3fv(shader->getUniformFromName("lights[1].color"), 1, glm::value_ptr(glm::vec3(0.0f, 1.0f, 0.0f)));

    // blue light
    glUniform3fv(shader->getUniformFromName("lights[2].position"), 1, glm::value_ptr(lightNode3->position));
    glUniform3fv(shader->getUniformFromName("lights[2].color"), 1, glm::value_ptr(glm::vec3(0.0f, 0.0f, 1.0f)));

    // moving light
    glUniform3fv(shader->getUniformFromName("lights[3].position"), 1, glm::value_ptr(movingLightNode->position));
    glUniform3fv(shader->getUniformFromName("lights[3].color"), 1, glm::value_ptr(glm::vec3(0.0f, 1.0f, 1.0f)));
};

void setup2Duniforms() {
    glUniformMatrix4fv(shader2d->getUniformFromName("ortho"), 1, GL_FALSE, glm::value_ptr(orthoVP));
}

void renderNode(SceneNode* node) {
    // Here we send the model matrix and the current transformation matrix
    glUniformMatrix4fv(3, 1, GL_FALSE, glm::value_ptr(node->currentTransformationMatrix));
    glUniformMatrix4fv(shader->getUniformFromName("modelMatrix"), 1, GL_FALSE, glm::value_ptr(node->modelMatrix));

    // Calculate and send normal matrix for normal transformation
    glm::mat3 normalMatrix = glm::transpose(glm::inverse(glm::mat3(node->modelMatrix)));
    glUniformMatrix3fv(shader->getUniformFromName("normalMatrix"), 1, GL_FALSE, glm::value_ptr(normalMatrix));

    // send ball position to shader
    glUniform3fv(shader->getUniformFromName("ballPosition"), 1, glm::value_ptr(ballPosition));

    switch(node->nodeType) {
        case GEOMETRY:
            if(node->vertexArrayObjectID != -1) {
                glUniform1i(shader->getUniformFromName("hasTexture"), 0);
                glBindVertexArray(node->vertexArrayObjectID);
                glDrawElements(GL_TRIANGLES, node->VAOIndexCount, GL_UNSIGNED_INT, nullptr);
            }
            break;
        case NORMAL_MAPPED:
            if(node->vertexArrayObjectID != -1) {
                glUniform1i(shader->getUniformFromName("hasTexture"), 1);
                glBindTextureUnit(0, node->textureID);
                glBindTextureUnit(1, node->normalMapID);
                glBindTextureUnit(2, node->roughnesstextureID);
                glBindVertexArray(node->vertexArrayObjectID);
                glDrawElements(GL_TRIANGLES, node->VAOIndexCount, GL_UNSIGNED_INT, nullptr);
            }
            break;
        case GEOMETRY_2D:
            if(node->vertexArrayObjectID != -1) {
                glUniformMatrix4fv(shader2d->getUniformFromName("MVP"), 1, GL_FALSE, glm::value_ptr(node->currentTransformationMatrix));
                glBindTextureUnit(0, node->textureID);
                glBindVertexArray(node->vertexArrayObjectID);
                glDrawElements(GL_TRIANGLES, node->VAOIndexCount, GL_UNSIGNED_INT, nullptr);
            }
            break;

        case POINT_LIGHT: break;
        case SPOT_LIGHT: break;
    }

    for(SceneNode* child : node->children) {
        renderNode(child);
    }
}

void renderFrame(GLFWwindow* window) {
    int windowWidth, windowHeight;
    glfwGetWindowSize(window, &windowWidth, &windowHeight);
    glViewport(0, 0, windowWidth, windowHeight);

    shader->activate();
    setup3Duniforms();
    renderNode(rootNode);

    shader2d->activate();
    setup2Duniforms();
    renderNode(rootNode2d);
}
