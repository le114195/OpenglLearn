//
//  MultiTextureView.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/6.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "MultiTextureView.h"


NSString *const TJ_MultiTextureVertexShaderString = TJ_STRING_ES
(
 attribute vec4 position;
 attribute vec2 textCoordinate;

 varying lowp vec2 varyTextCoord;
 
 void main()
{
    varyTextCoord = textCoordinate;
    gl_Position = position;
}
 );


NSString *const TJ_MultiTextureFragmentShaderString = TJ_STRING_ES
(
 varying lowp vec2 varyTextCoord;
 uniform sampler2D textureColor1;
 uniform sampler2D textureColor2;
 void main()
 {
//     if (varyTextCoord.x < 0.5) {
//         gl_FragColor = texture2D(textureColor2, varyTextCoord);
//     }else {
//         gl_FragColor = texture2D(textureColor1, varyTextCoord);
//     }
     
     gl_FragColor = texture2D(textureColor1, varyTextCoord);
 }
 );



@implementation MultiTextureView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        VertexShaderString = TJ_MultiTextureVertexShaderString;
        FragmentShaderString = TJ_MultiTextureFragmentShaderString;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupTexture];
    [self render];
}


- (void)setupTexture {
    
    UIImage *image1 = [UIImage imageNamed:@"sj_20160705_10.JPG"];
    glActiveTexture(GL_TEXTURE0);
    [self bindTextureImage:image1];
    //将纹理与片段着色器对应起来
    GLuint textureLocation1 = glGetUniformLocation(self.myProgram, "textureColor1");
    glUniform1i(textureLocation1, 0);
    
    UIImage *image2 = [UIImage imageNamed:@"sj_20160705_11.JPG"];
    glActiveTexture(GL_TEXTURE1);
    [self bindTextureImage:image2];
    //将纹理与片段着色器对应起来
    GLuint textureLocation2 = glGetUniformLocation(self.myProgram, "textureColor2");
    glUniform1i(textureLocation2, 1);
}

- (void)render {
    
    //坐标数组
    GLfloat attrArr[] =
    {
        0.5f, -0.5f, 0.0f,     1.0f, 1.0f,
        -0.5f, 0.5f, 0.0f,     0.0f, 0.0f,
        -0.5f, -0.5f, 0.0f,    0.0f, 1.0f,
        0.5f, 0.5f, 0.0f,      1.0f, 0.0f,
        -0.5f, 0.5f, 0.0f,     0.0f, 0.0f,
        0.5f, -0.5f, 0.0f,     1.0f, 1.0f,
    };
    
    GLfloat *attrP = attrArr;
    
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrP, GL_STATIC_DRAW);
    
    GLuint position = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(position);
    
    GLuint textCoor = glGetAttribLocation(self.myProgram, "textCoordinate");
    glVertexAttribPointer(textCoor, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (float *)NULL + 3);
    glEnableVertexAttribArray(textCoor);
    
    glClearColor(0, 0.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glDrawArrays(GL_TRIANGLES, 0, 12);
    
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}


@end
