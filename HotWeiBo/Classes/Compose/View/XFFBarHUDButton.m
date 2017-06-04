//
//  XFFBarHUDButton.m
//  HotWeiBo
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFBarHUDButton.h"

@implementation XFFBarHUDButton

-(UIActivityIndicatorView*)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:loadingView];
        self.loadingView = loadingView;
        
    }
    return _loadingView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
    
    // 文字宽度
    CGFloat titleW = [[self titleForState:(UIControlStateNormal)] sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
    
    // 图片尺度
    CGFloat imgWH = 15;
    CGFloat imgY = (self.frame.size.height - imgWH)*0.5;
    CGFloat imgX = (self.frame.size.width -titleW)*0.5 - imgWH-10;
    self.imageView.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
    
    // 设置位置和尺寸
    self.loadingView.center = self.imageView.center;
    
}


@end
