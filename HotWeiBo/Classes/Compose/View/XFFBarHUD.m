//
//  XFFBarHUD.m
//  HotWeiBo
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFBarHUD.h"
#import "XFFBarHUDButton.h"

static const NSTimeInterval XFFBarHUDDuratation = 0.5;
@implementation XFFBarHUD

static UIWindow *_window;
static XFFBarHUDButton *_button;

+ (void)initialize
{
    _window = [[UIWindow alloc]init];
    _window.height = 20;
    _window.transform = CGAffineTransformMakeTranslation(0, -_window.height);
    _window.width = [UIScreen mainScreen].bounds.size.width;
    _window.backgroundColor = [UIColor blackColor];
    _window.windowLevel = UIWindowLevelAlert;
    
    
    
    _button = [[XFFBarHUDButton alloc]init];
    [_button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _button.titleLabel.font = [UIFont systemFontOfSize:13];
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    _button.frame = _window.bounds;
    [_window addSubview:_button];
}
/**
 *  显示普通的信息
 */
+ (void)showMessage:(NSString *)msg image:(NSString *)image
{
#pragma mark 判断 HUD 是否已经存在
    if (_window.hidden == NO &&  !_button.loadingView.isAnimating)  return;
    
    _window.hidden = NO;
    
    [_button setTitle:msg forState:(UIControlStateNormal)];
    [_button setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    
    // 隐藏圈圈
    [_button.loadingView stopAnimating];
    
    [UIView animateWithDuration:XFFBarHUDDuratation animations:^{
        _window.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:XFFBarHUDDuratation delay:1.0 options:(UIViewAnimationOptionCurveLinear) animations:^{
            _window.transform = CGAffineTransformMakeTranslation(0, -_window.height);
        } completion:^(BOOL finished) {
            _window.hidden = YES;
        }];
    }];
}
/**
 *  显示成功的信息
 */
+ (void)showSuccess:(NSString *)msg{
    [self showMessage:msg image:@"XFFBarHUD.bundle/success"];
}
/**
 *  显示错误的信息
 */
+ (void)showError:(NSString *)msg{
       [self showMessage:msg image:@"XFFBarHUD.bundle/error"];
}

/**
 *  显示正在加载的信息
 */
+ (void)showLoading:(NSString *)msg{
    if (_window.hidden == NO) return;
    
    _window.hidden = NO;
    
    [_button setTitle:msg forState:(UIControlStateNormal)];
    // 清除图片
    [_button setImage:nil forState:(UIControlStateNormal)];
    [_button.loadingView startAnimating];
    
    [UIView animateWithDuration:XFFBarHUDDuratation animations:^{
        _window.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}
/**
 *  隐藏正在加载的信息
 */
+ (void)hideLoading{
    [UIView animateWithDuration:XFFBarHUDDuratation animations:^{
        _window.transform = CGAffineTransformMakeTranslation(0, -_window.height);
    } completion:^(BOOL finished) {
        [_button.loadingView stopAnimating];
        _window.hidden = YES;
    }];
}
@end
