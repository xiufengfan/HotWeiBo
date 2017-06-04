//
//  XFFEmotionPopView.m
//  HotWeiBo
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFEmotionPopView.h"
#import "XFFEmotionButton.h"

@interface  XFFEmotionPopView()
@property(nonatomic,weak)IBOutlet UIImageView *iconView;
@end
@implementation XFFEmotionPopView
+(instancetype)popView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"XFFEmotionPopView" owner:nil options:nil]lastObject];
}
/**
 * 从某个表情按钮上面弹出
 */
- (void)popFromEmotionButton:(XFFEmotionButton *)emotionButton
{
    // 显示图片
    self.iconView.image = emotionButton.currentImage;
    
    // 在按钮上显示一个放大镜
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 让放大镜显示在按钮上面
#pragma mark 坐标转换
    /*
    参数1：目的地View
    参数2：目标所在的rect
    参数3：目标 根据rect选在不同的目标 frame -> super   bounds -> self
   */
    CGRect buttonRect = [window convertRect:emotionButton.bounds fromView:emotionButton];
    self.centerX = CGRectGetMidX(buttonRect);
    self.y = CGRectGetMidY(buttonRect) - self.height;
}
@end
