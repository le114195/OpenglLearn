//
//  OpenGLViewController.m
//  OpenglLearn
//
//  Created by 勒俊 on 2017/6/7.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "OpenGLViewController.h"
#import "TJOpenglesCurve.h"
#import "TJ3DView.h"

@interface OpenGLViewController ()

@property (nonatomic, assign) int       type;

@end

@implementation OpenGLViewController


+ (instancetype) openGL:(int)type {
    
    OpenGLViewController *vc = [[OpenGLViewController alloc] init];
    vc.type = type;
    
    [vc typeAction];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)typeAction {
    
    switch (self.type) {
        case 0:
            [self curveView];
            break;
            
        case 1:
            [self openGL3D];
            break;
            
        default:
            break;
    }
    
}

/** 扭曲 */
- (void)curveView {
    
    UIImage *image = [UIImage imageNamed:@"sj_20160705_10.JPG"];
    
    TJOpenglesCurve *curve = [[TJOpenglesCurve alloc] initWithFrame:[self resetImageViewFrameWithImage:image top:64 bottom:0] image:image];
    [self.view addSubview:curve];
}


/** 3D */
- (void)openGL3D {
    
    TJ3DView *view = [[TJ3DView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}



@end
