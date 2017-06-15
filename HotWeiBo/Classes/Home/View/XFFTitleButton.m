//
//  XFFTitleButton.m
//  HotWeiBo
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFTitleButton.h"

@implementation XFFTitleButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        [self setupUI];
    }
    return self;
}

-(instancetype )initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
}

-(void)layoutSubviews
{
     [super layoutSubviews];
    self.titleLabel.x = 0;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
}

/*
 * 为什么重写这两个方法？
 * 因为每次文字、图片变化就要调用 sizeToFit 方法麻烦。
 */
-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self sizeToFit];
}

@end
