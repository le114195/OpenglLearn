//
//  NSArray+Safe.m
//  OpenglLearn
//
//  Created by 勒俊 on 2017/6/22.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "NSArray+Safe.h"
#import <objc/runtime.h>

@implementation NSArray (Safe)

+ (void)load
{
    Class class = NSClassFromString(@"__NSArrayI");
    
    Method safeMethod = class_getInstanceMethod(class, @selector(safeObjectAtIndex:));
    Method unsafeMethod = class_getInstanceMethod(class, @selector(objectAtIndex:));
    
    method_exchangeImplementations(unsafeMethod, safeMethod);
}


- (id)safeObjectAtIndex:(NSUInteger)index {
    
    if (index > self.count - 1) {
        NSLog(@"数组越界");
        return nil;
    }else {
        return [self safeObjectAtIndex:index];
    }
}


@end
