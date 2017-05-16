//
//  XFFPopMenu.h
//  HotWeiBo
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void(^DismissBlock)();

@interface XFFPopMenu : NSObject

/**
 *  弹出一个菜单
 *
 *  @param view    参照系
 *  @param rect    菜单的箭头指向的矩形框
 *  @param content 菜单里面的内容
 *  @param dismiss 菜单销毁的时候想做的事情
 */
+(void)popMenuFromRect:(CGRect)rect inView:(UIView *)view content:(UIView *)content dismiss:(DismissBlock)dismiss;

/**
 *  弹出一个菜单
 *
 *  @param view    菜单的箭头指向谁
 *  @param content 菜单里面的内容
 *  @param dismiss 菜单销毁的时候想做的事情
 */
+(void)popMenuFromView:(UIView*)view content:(UIView*)content dismiss:(DismissBlock)dismiss;


+(void)popMenuFromRect:(CGRect)rect inView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(DismissBlock)dismiss;

+(void)popMenuFromView:(UIView*)view contentVc:(UIViewController*)contentVc dismiss:(DismissBlock)dismiss;

@end
