//
//  XFFComposeToolBar.m
//  HotWeiBo
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFComposeToolBar.h"
@interface XFFComposeToolBar()
@property(nonatomic,weak)UIButton*emotionButton;
@end
@implementation XFFComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 添加按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:(XFFComposeToolbarButtonTypeCamera)];
        [self setupBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:(XFFComposeToolbarButtonTypePicture)];
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:(XFFComposeToolbarButtonTypeMention)];
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:(XFFComposeToolbarButtonTypeTrend)];
        self.emotionButton = [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:(XFFComposeToolbarButtonTypeEmotion)];
    }
    return self;
}


- (UIButton*)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(XFFComposeToolbarButtonType)type
{
    UIButton *button  = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:highImage] forState:(UIControlStateHighlighted)];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    button.tag = type;
    [self addSubview:button];
    return button;
}

-(void)switchEmotion:(BOOL)isEmotion
{
    NSString *imageName = @"compose_emoticonbutton_background";
    NSString *highImageName = @"compose_emoticonbutton_background_highlighted";
    if (isEmotion) {
        imageName = @"compose_keyboardbutton_background";
        highImageName = @"compose_keyboardbutton_background_highlighted";
    }
    [self.emotionButton setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    [self.emotionButton setImage:[UIImage imageNamed:highImageName] forState:(UIControlStateHighlighted)];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    CGFloat buttonW = self.width / count;
    CGFloat buttonH = self.height;
    for (NSUInteger i = 0; i<count; i++) {
        UIButton *button = self.subviews[i];
        button.y = 0;
        button.width = buttonW;
        button.height = buttonH;
        button.x = buttonW * i ;
    }
}

-(void)buttonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(composeToolBar:dicButtonClick:)] ) {
        [self.delegate composeToolBar:self dicButtonClick:(XFFComposeToolbarButtonType)button.tag];
    }
}
@end
