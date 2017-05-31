//
//  XFFTabBar.m
//  HotWeiBo
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFTabBar.h"
#import "XFFComposeViewController.h"
/*
 * 1.在layoutSubViews中修改 UITabBarButton 子类的 frame
 * 2.定义初始化方法
 * 3.初始化加号按钮
 * 4.在layoutSubViews中修改 加号按钮 的 frame
 */

@interface  XFFTabBar()
@property(nonatomic,weak)UIButton *plusBtn;

@end

@implementation XFFTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIButton *plusBtn = [[UIButton alloc]init];
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:(UIControlStateNormal)];
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    
    [plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:plusBtn];
    
     self.plusBtn = plusBtn;
}

-(void)plusBtnClick:(UIButton*)btn{
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    XFFComposeViewController *composeVc = [[XFFComposeViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController: composeVc] ;
    [rootVc presentViewController:nav animated:YES completion:nil];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置tabbarbutton 的frame
    CGFloat buttonW = self.width / 5.0;
    CGFloat buttonH = self.height;
    CGFloat buttonIndex = 0;
    
    for (UIView *childView in self.subviews) {
        // 判断属于 UITabBarButton 类型
        if([childView isKindOfClass:[UIControl class]] && ![childView isKindOfClass:[UIButton class]]){
//        if ([childView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
        
            CGFloat buttonX = buttonW * buttonIndex;
            childView.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
            
            buttonIndex ++;
            
            if (buttonIndex == 2) {
                buttonIndex ++;
            }
        }
    }
    
    // 设置加好按钮的frame
    CGSize plusBtnSize = self.plusBtn.currentBackgroundImage.size;
    self.plusBtn.frame = CGRectMake(0, 0, plusBtnSize.width, plusBtnSize.height);
    self.plusBtn.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
}

@end
