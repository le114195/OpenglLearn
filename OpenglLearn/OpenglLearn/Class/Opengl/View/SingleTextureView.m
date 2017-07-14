//
//  SingleTextureView.m
//  OpenglLearn
//
//  Created by 勒俊 on 2017/6/28.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "SingleTextureView.h"


NSString *const TJ_SingleTextureVertexShaderString = TJ_STRING_ES
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


NSString *const TJ_SingleTextureFragmentShaderString = TJ_STRING_ES
(
 varying lowp vec2 varyTextCoord;
 uniform sampler2D textureColor1;
 uniform sampler2D textureColor2;
 void main()
 {
     if (varyTextCoord.x < 0.5) {
         gl_FragColor = texture2D(textureColor2, varyTextCoord);
     }else {
         gl_FragColor = texture2D(textureColor1, varyTextCoord);
     }
 }
 );

@implementation SingleTextureView







@end
