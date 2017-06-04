//
//  XFFBarHUD.h
//  HotWeiBo
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFFBarHUD : NSObject
/**
 *  显示普通的信息
 */
+ (void)showMessage:(NSString *)msg image:(NSString *)image;
/**
 *  显示成功的信息
 */
+ (void)showSuccess:(NSString *)msg;
/**
 *  显示错误的信息
 */
+ (void)showError:(NSString *)msg;

/**
 *  显示正在加载的信息
 */
+ (void)showLoading:(NSString *)msg;
/**
 *  隐藏正在加载的信息
 */
+ (void)hideLoading;
@end
