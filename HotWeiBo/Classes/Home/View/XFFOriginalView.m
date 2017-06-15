//
//  XFFOriginalView.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFOriginalView.h"
#import "XFFStatusFrame.h"
#import "XFFStatus.h"
#import "XFFUser.h"
#import "UIImageView+WebCache.h"
#import "XFFPicturesView.h"
#import "XFFStatusTextView.h"

@interface XFFOriginalView()
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文\内容 */
@property (nonatomic, weak) XFFStatusTextView *contentLabel;

@property(nonatomic,weak)XFFPicturesView *picturesView;
@end

@implementation XFFOriginalView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化子控件
        
        /** 2.头像 */
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        /** 3.昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        self.nameLabel.font = XFFCellNameFont;
        
        /** 4.会员图标 */
        UIImageView *vipView = [[UIImageView alloc] init];
        [self addSubview:vipView];
        self.vipView = vipView;
        
        /** 5.时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        self.timeLabel.font = XFFCellTimeFont;
        self.timeLabel.textColor = [UIColor orangeColor];
        
        /** 6.来源 */
        UILabel *sourceLabel = [[UILabel alloc] init];
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        self.sourceLabel.font = XFFCellSourceFont;
        
        /** 7.正文\内容 */
        XFFStatusTextView *contentLabel = [[XFFStatusTextView alloc] init];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
//        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = XFFCellContentFont;
        
        /** 8.配图容器 */
        XFFPicturesView *picturesView = [[XFFPicturesView alloc]init];
        [self addSubview:picturesView];
        self.picturesView = picturesView;
    }
    return self;
}

-(void)setStatusFrame:(XFFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    self.frame = _statusFrame.orginalViewF;
    
    [self setupData];
    
    [self setupFrame];
}

-(void)setupData
{
    XFFStatus *status = _statusFrame.status;
    XFFUser *user = status.user;
    
    NSURL *iconURL = [NSURL URLWithString:user.profile_image_url];
    [self.iconView sd_setImageWithURL:iconURL placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    self.nameLabel.text = user.name;
    
    if (user.isVip) {
        NSString *vipImageName = [NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipImageName];
        self.vipView.hidden =  NO;
        
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    self.timeLabel.text = status.created_at;
    
    self.sourceLabel.text = status.source;
    
    self.contentLabel.attributedText = status.attributedText;
    
    /** 配图容器 */
    if(status.pic_urls.count>0){
        self.picturesView.pic_urls = status.pic_urls;
    }
    
}

-(void)setupFrame
{
    /** 1.头像 */
    self.iconView.frame = self.statusFrame.iconViewF;
    
    /** 2.昵称 */
    self.nameLabel.frame = self.statusFrame.nameLabelF;
    
    /** 3.会员图标 */
    self.vipView.frame = self.statusFrame.vipViewF;
    
    
    XFFStatus *status = self.statusFrame.status;
    
    CGFloat timeX = self.statusFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(self.statusFrame.nameLabelF) + XFFCellMargin * 0.5;
    CGSize timeSize = [status.created_at sizeWithAttributes:@{NSFontAttributeName:XFFCellTimeFont}];
    self.timeLabel.frame = (CGRect){{timeX,timeY},timeSize};
    
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + XFFCellMargin;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithAttributes:@{NSFontAttributeName: XFFCellSourceFont}];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 6.正文\内容 */
    self.contentLabel.frame = self.statusFrame.contentLabelF;
    
    /** 7.配图容器 */
    if(status.pic_urls.count>0)
    {
        self.picturesView.hidden = NO;
        self.picturesView.frame = self.statusFrame.picturesViewF;
    }else{
        self.picturesView.hidden = YES;
    }
}

@end
