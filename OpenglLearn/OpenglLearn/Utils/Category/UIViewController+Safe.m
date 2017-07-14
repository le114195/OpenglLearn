//
//  UIViewController+Safe.m
//  OpenglLearn
//
//  Created by 勒俊 on 2017/6/22.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "UIViewController+Safe.h"
#import <objc/runtime.h>



@implementation UIViewController (Safe)


+ (void)load
{
    Class class = NSClassFromString(@"UIViewController");
    
    Method unsafeMethod = class_getInstanceMethod(class, @selector(viewDidLoad));
    Method safeMethod = class_getInstanceMethod(class, @selector(newViewDidLoad));
    
    method_exchangeImplementations(unsafeMethod, safeMethod);
}


- (void)newViewDidLoad {
    
    NSLog(@"6666666");
    
}


@end
