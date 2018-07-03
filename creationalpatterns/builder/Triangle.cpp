#include "Triangle.hpp"
#include <iostream>
#include <stdio.h>

using namespace std;
void Triangle::setVertexShader(const char* vertexShader) {
    char *b = new char[strlen(vertexShader) + 1]{};
    copy(vertexShader, vertexShader + strlen(vertexShader), b);
    this->vertexShader = b;
}
void Triangle::setFragmentShader(const char* fragmentShader) {
    char *b = new char[strlen(fragmentShader) + 1]{};
    copy(fragmentShader, fragmentShader + strlen(fragmentShader), b);
    this->fragmentShader = b;
}
void Triangle::compileVertexShader() {
    this->vertexShaderID = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(this->vertexShaderID, 1, &this->vertexShader, NULL);
    glCompileShader(this->vertexShaderID);
    int success;
    char infoLog[512];
    glGetShaderiv(this->vertexShaderID, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(this->vertexShaderID, 512, NULL, infoLog);
        cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << endl;
    }
}
void Triangle::compileFragmentShader() {
    this->fragmentShaderID = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(this->fragmentShaderID, 1, &this->fragmentShader, NULL);
    glCompileShader(this->fragmentShaderID);
    int success;
    char infoLog[512];
    glGetShaderiv(this->fragmentShaderID, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(this->fragmentShaderID, 512, NULL, infoLog);
        cout << "ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n" << infoLog << endl;
    }
}
void Triangle::linkProgram() {
    this->shaderProgram = glCreateProgram();
    glAttachShader(this->shaderProgram, this->vertexShaderID);
    glAttachShader(this->shaderProgram, this->fragmentShaderID);
    glLinkProgram(this->shaderProgram);
    int success;
    char infoLog[512];
    glGetProgramiv(this->shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(this->shaderProgram, 512, NULL, infoLog);
        cout << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << infoLog << endl;
    }
}
void Triangle::deleteShaders() {
    glDeleteShader(this->vertexShaderID);
    glDeleteShader(this->fragmentShaderID);
}
void Triangle::setVertices(vector<float> vertices) {
    this->vertices = vertices;
}
void Triangle::generateVertexArrayObject() {
    glGenVertexArrays(1, &this->VAO);
    glGenBuffers(1, &this->VBO);
    glBindVertexArray(this->VAO);
    glBindBuffer(GL_ARRAY_BUFFER, this->VBO);
    glBufferData(GL_ARRAY_BUFFER, this->vertices.size() * sizeof(float), this->vertices.data(), GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}
