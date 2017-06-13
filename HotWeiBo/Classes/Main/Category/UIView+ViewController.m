//
//  UIView+ViewController.m
//  HotWeiBo
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)
#pragma mark - 获取当前view的viewcontroller
+ (UIViewController *)getCurrentViewController:(UIView *) currentView
{
    for (UIView* next = [currentView superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
