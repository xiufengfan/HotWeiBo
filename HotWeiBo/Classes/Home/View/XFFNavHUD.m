//
//  XFFNavHUD.m
//  HotWeiBo
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFNavHUD.h"

@implementation XFFNavHUD

static UILabel *_label;

+ (void)initialize
{
    _label = [[UILabel alloc]init];
    _label.textAlignment = NSTextAlignmentCenter;

#pragma Mark 通过一个图片平铺获取北京颜色
    _label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    _label.width = [UIScreen mainScreen].bounds.size.width;
    _label.height = 35;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:17];
    _label.y = 64 - _label.height;
}

+(void)showMessage:(NSString*)msg view:(UIView *)view{
    _label.text = msg;

#pragma mark 添加到导航条会导致push到自控制器后提示还存在
    /*
    [vc.navigationController.view insertSubview:_label belowSubview:vc.navigationController.navigationBar];
    */
    [view addSubview:_label];
    [UIView animateWithDuration:1.0 animations:^{
        _label.y = 64;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:1.0 options:(UIViewAnimationOptionCurveLinear) animations:^{
            _label.y = 64 - _label.height;
        } completion:^(BOOL finished) {
            [_label removeFromSuperview];
        }];
    }];
}
@end
