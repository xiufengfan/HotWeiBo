//
//  XFFImageView.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFImageView.h"
#import "XFFPicUrl.h"
#import "UIImageView+WebCache.h"
@interface XFFImageView ()
@property(nonatomic,weak)UIImageView *gifImageView;
@end

@implementation XFFImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *gifImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        // 设置图片内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 剪去因为拉伸而多余的部分
        self.clipsToBounds = YES;
        [self addSubview:gifImageView];
        self.gifImageView = gifImageView;
    }
    return self;
}

-(void)setPic_url:(XFFPicUrl *)pic_url
{
    _pic_url = pic_url;
    self.gifImageView.hidden = ![_pic_url.thumbnail_pic.pathExtension.lowercaseString isEqualToString:@"gif"];
    NSURL *url = [NSURL URLWithString:pic_url.thumbnail_pic];
//    XFFLog(@"%@",_pic_url.thumbnail_pic);
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifImageView.x = self.width - self.gifImageView.width;
    self.gifImageView.y = self.height - self.gifImageView.height;
}

@end
