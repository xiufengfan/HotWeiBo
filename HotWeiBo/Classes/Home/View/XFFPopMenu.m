//
//  XFFPopMenu.m
//  HotWeiBo
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFPopMenu.h"
@interface XFFPopMenu ()
@property(nonatomic,weak)UIButton *cover;
@property(nonatomic,weak)UIImageView *container;
@end

@implementation XFFPopMenu
static UIButton *_cover;
static UIImageView *_container;
static DismissBlock _dismiss;
static UIViewController *_contentVc;

+(void)popMenuFromRect:(CGRect)rect inView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(DismissBlock)dismiss
{
    _contentVc = contentVc;
    
    [self popMenuFromRect:rect inView:view content:contentVc.view dismiss:dismiss];
}

+(void)popMenuFromView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(DismissBlock)dismiss
{
    _contentVc = contentVc;
    [self popMenuFromView:view content:contentVc.view dismiss:dismiss];
}

+(void)popMenuFromRect:(CGRect)rect inView:(UIView *)view content:(UIView *)content dismiss:(DismissBlock)dismiss
{
    _dismiss = [dismiss copy];
    // 获取最上层的window
    UIWindow *window  = [[UIApplication sharedApplication].windows lastObject];
    
    // 遮盖层
    UIButton *cover = [[UIButton alloc]init];
    cover.frame = window.bounds;
    cover.backgroundColor = [UIColor clearColor];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview: cover];
    _cover = cover;
    
    // 容器（背景）视图
    UIImageView *container = [[UIImageView alloc]init];
    container.userInteractionEnabled = YES;
    container.image = [UIImage imageNamed:@"popover_background"];
    [window addSubview:container];
    _container = container;
    // 添加内容到容器
    content.x = 15;
    content.y = 18;
    [container addSubview:content];
    // 计算容器的尺寸
    container.width = CGRectGetMaxX(content.frame) + content.x;
    container.height = CGRectGetMaxY(content.frame) + content.y;
    container.centerX = CGRectGetMidX(rect);
    container.y = CGRectGetMaxY(rect);
    // 转换位置
    container.center = [view convertPoint:container.center toView:window];
}
+(void)popMenuFromView:(UIView*)view content:(UIView*)content dismiss:(DismissBlock)dismiss{
    
    [self popMenuFromRect:view.bounds inView:view content:content dismiss:dismiss];
}

+(void)coverClick{
    [_cover removeFromSuperview];
    _cover = nil;
    [_container removeFromSuperview];
    _container = nil;
    
    _contentVc = nil;
    
    if(_dismiss){
        _dismiss();
        _dismiss = nil;
    }
}

@end
