//
//  UIBarButtonItem+Extension.h
//  HotWeiBo
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 为什么要使用自定义视图来创建barbuttonitem?
 * 因为系统提供的初始化方法不能设置图片的高亮状态。
 * 
 * 为什么采用扩展的方式？
 * 因为更容易理解学习方便，而且只涉及到 UIBarButtonItem 对象。
 *
 * 抽取方法最后无法设置是 leftBarButtonItem 还是 rigtBarButtonItem,所以返回BarButtonItem 由用户自己设置。
 */
@interface UIBarButtonItem (Extension)
+(UIBarButtonItem*)itemWithBackgroundImage:(NSString*)backgroundImage highlightedImage:(NSString*)highlightedImage target:(id)target action:(SEL)action;
@end
