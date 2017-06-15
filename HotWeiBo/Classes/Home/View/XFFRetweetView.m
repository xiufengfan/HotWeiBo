//
//  XFFRetweetView.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFRetweetView.h"
#import "XFFStatusFrame.h"
#import "XFFStatus.h"
#import "XFFUser.h"
#import "XFFPicturesView.h"
#import "XFFStatusTextView.h"
@interface XFFRetweetView()
/** 转发正文\内容 */
@property (nonatomic, weak) XFFStatusTextView *retweetContentLabel;

@property(nonatomic,weak)XFFPicturesView *retweetPicturesView;
@end
@implementation XFFRetweetView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 转发正文
        XFFStatusTextView *retweetContentLabel = [[XFFStatusTextView alloc] init];
        [self addSubview:retweetContentLabel];
        self.retweetContentLabel = retweetContentLabel;
        retweetContentLabel.font = XFFCellContentFont;
//        retweetContentLabel.numberOfLines = 0;
        
        XFFPicturesView *retweetPictureView = [[XFFPicturesView alloc]init];
        [self addSubview:retweetPictureView];
        self.retweetPicturesView = retweetPictureView;
    }
    return self;
}

-(void)setStatusFrame:(XFFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    self.frame = _statusFrame.retweetViewF;
    
    // 设置数据
    [self setupData];
    
    // 设置frame
    [self setupFrame];
}

-(void)setupData
{
    XFFStatus *status = self.statusFrame.status;
    
//    self.retweetContentLabel.text = [NSString stringWithFormat:@"@%@: %@", status.retweeted_status.user.name, status.retweeted_status.text];
    self.retweetContentLabel.attributedText = status.retweetedAttributedText;
    
    if (status.retweeted_status.pic_urls.count>0) {
        self.retweetPicturesView.pic_urls = status.retweeted_status.pic_urls;
    }
}
-(void)setupFrame
{
    // 8.转发正文
    self.retweetContentLabel.frame = self.statusFrame.retweetContentLabelF;
    
    /** 7.配图容器 */
    if(self.statusFrame.status.retweeted_status.pic_urls.count>0)
    {
        self.retweetPicturesView.hidden = NO;
        self.retweetPicturesView.frame = self.statusFrame.retweetPicturesViewF;
    }else{
        self.retweetPicturesView.hidden = YES;
    }
}
@end
