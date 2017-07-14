//
//  XL3DView1.m
//  OpenglLearn
//
//  Created by 勒俊 on 2017/6/29.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "XL3DView1.h"
#import "GLESMath.h"


NSString *const TJ_XL3D1VertexShaderString = TJ_STRING_ES
(
 attribute vec4 position;
 attribute vec4 positionColor;
 uniform mat4 projectionMatrix;
 uniform mat4 modelViewMatrix;
 
 varying lowp vec4 varyColor;
 
 void main()
{
    varyColor = positionColor;
    vec4 vPos;
    vPos = projectionMatrix * modelViewMatrix * position;
    gl_Position = vPos;
}
 );


NSString *const TJ_XL3D1FragmentShaderString = TJ_STRING_ES
(
 
 varying lowp vec4 varyColor;
 
 void main()
{
    gl_FragColor = varyColor;
}
 
 );





@implementation XL3DView1

{
    float xdegree;
    float yDegree;
    float translationX;
    float translationY;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        VertexShaderString = TJ_XL3D1VertexShaderString;
        FragmentShaderString = TJ_XL3D1FragmentShaderString;
        
        xdegree = 30;
        yDegree = 0;
        
        UIPanGestureRecognizer *panMove = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoveAction:)];
        panMove.minimumNumberOfTouches = 2;
        panMove.maximumNumberOfTouches = 2;
        [self addGestureRecognizer:panMove];
        
        UIPanGestureRecognizer *panRotion = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRotionAction:)];
        panRotion.minimumNumberOfTouches = 1;
        panRotion.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:panRotion];
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    [self render];
}

- (void)render {
    
    glClearColor(0, 0.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLuint indices[] =
    {
        0, 2, 3,
        3, 1, 0,
        4, 5, 7,
        7, 6, 4,

    };
    
    GLfloat attrArr[] =
    {
        -0.5f, 0.5f, -0.5f,      1.0f, 0.0f, 1.0f, //左上(底)
        0.5f, 0.5f, -0.5f,       1.0f, 0.0f, 1.0f, //右上(底)
        -0.5f, -0.5f, -0.5f,     1.0f, 1.0f, 1.0f, //左下(底)
        0.5f, -0.5f, -0.5f,      1.0f, 1.0f, 1.0f, //右下(底)
        
        -0.5f, 0.5f, 0.5f,      1.0f, 0.0f, 1.0f, //左上(顶)
        0.5f, 0.5f, 0.5f,       1.0f, 0.0f, 1.0f, //右上(顶)
        -0.5f, -0.5f, 0.5f,     1.0f, 1.0f, 1.0f, //左下(顶)
        0.5f, -0.5f, 0.5f,      1.0f, 1.0f, 1.0f, //右下(顶)
    };
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_STATIC_DRAW);
    
    
    GLuint position = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 6, NULL);
    glEnableVertexAttribArray(position);
    
    GLuint positionColor = glGetAttribLocation(self.myProgram, "positionColor");
    glVertexAttribPointer(positionColor, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 6, (float *)NULL + 3);
    glEnableVertexAttribArray(positionColor);
    
    GLuint projectionMatrixSlot = glGetUniformLocation(self.myProgram, "projectionMatrix");
    GLuint modelViewMatrixSlot = glGetUniformLocation(self.myProgram, "modelViewMatrix");
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    KSMatrix4 _projectionMatrix;
    ksMatrixLoadIdentity(&_projectionMatrix);
    float aspect = width / height; //长宽比
    
    ksPerspective(&_projectionMatrix, 30.0, aspect, 5.0f, 20.0f); //透视变换，视角30°
    
    //设置glsl里面的投影矩阵
    glUniformMatrix4fv(projectionMatrixSlot, 1, GL_FALSE, (GLfloat*)&_projectionMatrix.m[0][0]);
    glEnable(GL_CULL_FACE);
    
    
    //平移
    KSMatrix4 _modelViewMatrix;
    ksMatrixLoadIdentity(&_modelViewMatrix);
    ksTranslate(&_modelViewMatrix, 0.0, 0.0, -10.0);
    
    //旋转
    KSMatrix4 _rotationMatrix;
    ksMatrixLoadIdentity(&_rotationMatrix);
    ksRotate(&_rotationMatrix, xdegree, 1.0, 0.0, 0.0); //绕X轴
    ksRotate(&_rotationMatrix, yDegree, 0.0, 1.0, 0.0); //绕Y轴
    
    //把变换矩阵相乘，注意先后顺序（顺序：缩放->旋转->平移）
    ksMatrixMultiply(&_modelViewMatrix, &_rotationMatrix, &_modelViewMatrix);
    //    ksMatrixMultiply(&_modelViewMatrix, &_modelViewMatrix, &_rotationMatrix);
    
    // Load the model-view matrix
    glUniformMatrix4fv(modelViewMatrixSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
    glDrawElements(GL_TRIANGLES, sizeof(indices) / sizeof(indices[0]), GL_UNSIGNED_INT, indices);
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)panMoveAction:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:self];
    
    NSLog(@"%@", NSStringFromCGPoint(translation));
}


- (void)panRotionAction:(UIPanGestureRecognizer *)panGesture
{
    static CGFloat trX = 0;
    static CGFloat trY = 0;
    
    CGPoint translation = [panGesture translationInView:self];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        trX = xdegree;
        trY = yDegree;
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        xdegree = trX - translation.y / Screen_Width * 180;
        yDegree = trY - translation.x / Screen_Width * 180;
        
        [self render];
    }else if (panGesture.state == UIGestureRecognizerStateEnded) {
        
    }
}


@end
