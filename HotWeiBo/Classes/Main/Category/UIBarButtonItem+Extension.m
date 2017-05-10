//
//  UIBarButtonItem+Extension.m
//  HotWeiBo
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+(instancetype)itemWithBackgroundImage:(NSString*)backgroundImage highlightedImage:(NSString*)highlightedImage target:(id)target action:(SEL)action{
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:(UIControlStateNormal)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:(UIControlStateHighlighted)];
    leftBtn.size = leftBtn.currentBackgroundImage.size;
    [leftBtn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    return [[self alloc]initWithCustomView:leftBtn];
}
@end
