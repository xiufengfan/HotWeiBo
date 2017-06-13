//
//  XFFStatusFrame.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFStatusFrame.h"
#import "XFFStatus.h"
#import "XFFUser.h"
#import "XFFPicturesView.h"

@implementation XFFStatusFrame
-(void)setStatus:(XFFStatus *)status
{
    _status = status;
    
    // 1.计算原创微博frame
    [self setupOriginalFrame];
    
    // 2.计算转发微博frame
    [self setupRetweetedFrame];
    
    // 3.计算顶部容器frame
    [self setupTopFrame];
    
    // 4.计算底部容器frame
    [self setupBottomFrame];
    
    // 5.cell的高度
    _cellHeight = CGRectGetMaxY(_bottomViewF);
}

-(void)setupOriginalFrame
{
    /** 头像 */
    CGFloat iconX = XFFCellMargin;
    CGFloat iconY = XFFCellMargin;
    CGFloat iconWidth = 35;
    CGFloat iconHeight = 35;
    _iconViewF = (CGRect){{iconX, iconY}, {iconWidth, iconHeight}};
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(_iconViewF) + XFFCellMargin;
    CGFloat nameY = iconY;
    CGSize nameSize = [_status.user.name sizeWithAttributes:@{NSFontAttributeName:XFFCellNameFont}];
    _nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    CGFloat vipX = CGRectGetMaxX(_nameLabelF) + XFFCellMargin;
    CGFloat vipY = iconY;
    CGFloat vipW = 14;
    CGFloat vipH = 14;
    _vipViewF = (CGRect){{vipX, vipY}, {vipW, vipH}};
    
    
    /** 正文\内容 */
    CGFloat contentX = iconX;
    CGFloat contentY = CGRectGetMaxY(_iconViewF) + XFFCellMargin;
    CGSize contentMaxSize = CGSizeMake(XFFScreenWidth - XFFCellMargin - XFFCellMargin, CGFLOAT_MAX);
//    CGSize contentSize = [_status.text sizeWithFont:XFFCellContentFont constrainedToSize:contentMaxSize];
    CGRect contentRect = [_status.text boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XFFCellContentFont} context:nil];
    _contentLabelF = (CGRect){{contentX, contentY}, contentRect.size};
    
    // 计算配图容器的frame
    CGFloat orginalH = 0.0;
    if (_status.pic_urls.count) {
        NSUInteger photoCount = _status.pic_urls.count;
        
        CGSize photoSize = [XFFPicturesView sizeWithPhotoCount:photoCount];
        CGFloat photoX = iconX;
        CGFloat photoY = CGRectGetMaxY(_contentLabelF)+ XFFCellMargin;
        _picturesViewF = (CGRect){{photoX,photoY},photoSize};
        
        orginalH = CGRectGetMaxY(_picturesViewF);
    }else{
        orginalH = CGRectGetMaxY(_contentLabelF);
    }
    
    
    /** 原创微博 */
    CGFloat orginalX = 0;
    CGFloat orginalY = 0;
    CGFloat orginalW = XFFScreenWidth;
    _orginalViewF = (CGRect){{orginalX, orginalY}, {orginalW, orginalH}};
}


-(void)setupRetweetedFrame
{
    // 取出转发微博
    XFFStatus *retweetedStatus = _status.retweeted_status;
    if (retweetedStatus != nil) {
        // 有转发
        
        // 转发的正文
        CGFloat retweetContentX = XFFCellMargin;
        CGFloat retweetContentY = XFFCellMargin;
        CGSize retweetContentMaxSize = CGSizeMake(XFFScreenWidth - XFFCellMargin - XFFCellMargin, CGFLOAT_MAX);
        CGRect retweetContentRect = [retweetedStatus.text boundingRectWithSize:retweetContentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XFFCellContentFont} context:nil];
        
        _retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentRect.size};
        
        // 计算配图容器的frame
        CGFloat retweetH = 0.0;
        if (retweetedStatus.pic_urls.count) {
            NSUInteger photoCount = retweetedStatus.pic_urls.count;
            
            CGSize photoSize = [XFFPicturesView sizeWithPhotoCount:photoCount];
            CGFloat photoX = retweetContentX;
            CGFloat photoY = CGRectGetMaxY(_retweetContentLabelF)+ XFFCellMargin;
            _retweetPicturesViewF = (CGRect){{photoX,photoY},photoSize};
            
            retweetH = CGRectGetMaxY(_retweetPicturesViewF);
        }else{
            retweetH = CGRectGetMaxY(_retweetContentLabelF) + XFFCellMargin;
        }
        
        // 转发微博
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(_orginalViewF) + XFFCellMargin;
        CGFloat retweetW = XFFScreenWidth;
        _retweetViewF = (CGRect){{retweetX, retweetY}, {retweetW, retweetH}};
        
    }

}

-(void)setupTopFrame
{
    CGFloat topX = 0;
    CGFloat topY = 20;
    CGFloat topW = XFFScreenWidth;
    // 取出转发微博
    XFFStatus *retweetedStatus = _status.retweeted_status;
    CGFloat topH = 0.0;
    if (retweetedStatus != nil)
    {
        topH = CGRectGetMaxY(_retweetViewF);
    }else
    {
        // 没有转发微博
        // 顶部视图高度 = 原创微博最大的Y + 间隙
        topH = CGRectGetMaxY(_orginalViewF);
    }
    _topViewF = (CGRect){{topX, topY}, {topW, topH}};
}

-(void)setupBottomFrame
{
    CGFloat bottomX = 0;
    CGFloat bottomY = CGRectGetMaxY(_topViewF);
    CGFloat bottomW = XFFScreenWidth;
    CGFloat bottomH = 35;
    _bottomViewF = (CGRect){{bottomX, bottomY}, {bottomW, bottomH}};
}
@end
