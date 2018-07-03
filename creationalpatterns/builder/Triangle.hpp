#ifndef Triangle_hpp
#define Triangle_hpp
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl3.h>
#import <vector>
using namespace std;
class Triangle{
public:
    void setVertexShader(const char*);
    void setFragmentShader(const char*);
    void compileVertexShader();
    void compileFragmentShader();
    void linkProgram();
    void deleteShaders();
    void setVertices(vector<float> );
    void generateVertexArrayObject();
    ~Triangle() {};
    GLuint shaderProgram;
    GLuint VAO;
private:
    char* vertexShader;
    char* fragmentShader;
    
    GLuint VBO;
    
    int vertexShaderID;
    int fragmentShaderID;
    vector<float> vertices;
};

#endif
