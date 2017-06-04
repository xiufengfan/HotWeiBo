//
//  XFFEmotionKeyboard.m
//  HotWeiBo
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFEmotionKeyboard.h"
#import "XFFEmotionContentView.h"
#import "XFFEmotionDao.h"
@interface XFFEmotionToolbarButton : UIButton
@end
@implementation XFFEmotionToolbarButton
- (void)setHighlighted:(BOOL)highlighted {}
@end

@interface XFFEmotionKeyboard()
@property(nonatomic,weak)UIView*toolBar;
@property(nonatomic,weak)XFFEmotionToolbarButton*selectedButton;

@property(nonatomic,strong)XFFEmotionContentView*defaultContentView;
@property(nonatomic,strong)XFFEmotionContentView*recentContentView;
@property(nonatomic,strong)XFFEmotionContentView*lxhContentView;

@property(nonatomic,weak)XFFEmotionContentView*selectedContentView;

@end
static NSString * const XFFDefaultText = @"默认";
static NSString * const XFFRecentText = @"最近";
static NSString * const XFFLxhText = @"浪小花";

@implementation XFFEmotionKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupToolBar];
    }
    return self;
}
-(XFFEmotionContentView*)defaultContentView
{
    if (!_defaultContentView) {
        self.defaultContentView = [[XFFEmotionContentView alloc]init];
        self.defaultContentView.emotions = [XFFEmotionDao defaultEmotions];
    }
    return _defaultContentView;
}

-(XFFEmotionContentView*)recentContentView
{
    if (!_recentContentView) {
        self.recentContentView = [[XFFEmotionContentView alloc]init];
        self.recentContentView.emotions = [XFFEmotionDao recentEmotions];
    }
    return _recentContentView;
}

-(XFFEmotionContentView*)lxhContentView
{
    if (!_lxhContentView) {
        self.lxhContentView = [[XFFEmotionContentView alloc]init];
        self.lxhContentView.emotions = [XFFEmotionDao lxhEmotions];
    }
    return _lxhContentView;
}


-(void)setupToolBar
{
    // 创建工具条
    UIView *toolBar = [[UIView alloc]init];
    [self addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 创建工具条按钮
    [self setupButton:XFFRecentText];
    [self buttonClick: [self setupButton:XFFDefaultText]];
    [self setupButton:XFFLxhText];
}

-(XFFEmotionToolbarButton*)setupButton:(NSString*)title
{
    XFFEmotionToolbarButton *btn = [[XFFEmotionToolbarButton alloc]init];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateDisabled)];
    
    [btn setBackgroundImage :[UIImage imageNamed:@"compose_emotion_table_mid_normal"] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_mid_selected"] forState:(UIControlStateDisabled)];
    
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchDown)];
    [self.toolBar addSubview:btn];
    return btn;
}

-(void)buttonClick:(XFFEmotionToolbarButton*)button
{
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    [self.selectedContentView removeFromSuperview];
    
    if([button.currentTitle isEqualToString:XFFDefaultText]){
        [self addSubview:self.defaultContentView];
        self.selectedContentView = self.defaultContentView;
    }else if([button.currentTitle isEqualToString:XFFRecentText]){
        [self addSubview:self.recentContentView];
        self.selectedContentView = self.recentContentView;
    }else if([button.currentTitle isEqualToString:XFFLxhText]){
        [self addSubview:self.lxhContentView];
        self.selectedContentView = self.lxhContentView;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.toolBar.x = 0;
    self.toolBar.height = 44;
    self.toolBar.width = self.width;
    self.toolBar.y = self.height - self.toolBar.height;
    
    NSUInteger count=self.toolBar.subviews.count;
    CGFloat btnW = self.width / count;
    for (NSUInteger i = 0; i<count; i++) {
        XFFEmotionToolbarButton *btn = self.toolBar.subviews[i];
        btn.width = btnW;
        btn.height = self.toolBar.height;
        btn.y = 0;
        btn.x = i * btnW;
    }
    
    self.selectedContentView.width = self.width;
    self.selectedContentView.height = self.toolBar.y;
}

@end
