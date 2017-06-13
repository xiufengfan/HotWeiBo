//
//  XFFStatusFrame.h
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>
// 间隙
#define XFFCellMargin 10
#define XFFCellNameFont [UIFont systemFontOfSize:16]
#define XFFCellTimeFont  [UIFont systemFontOfSize:13]
#define XFFCellSourceFont    XFFCellTimeFont
#define XFFCellContentFont   [UIFont systemFontOfSize:16]
@class XFFStatus;
@interface XFFStatusFrame : NSObject
@property(nonatomic,strong)XFFStatus *status;

@property(nonatomic,assign,readonly)CGRect topViewF;
/*****************华丽的分割线****************************/
@property(nonatomic,assign,readonly)CGRect orginalViewF;
/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/** 会员图标 */
@property (nonatomic, assign, readonly) CGRect vipViewF;

@property(nonatomic,assign,readonly)CGRect contentLabelF;


/*****************华丽的分割线****************************/
@property(nonatomic,assign,readonly)CGRect retweetViewF;

@property(nonatomic,assign,readonly)CGRect retweetContentLabelF;


/*****************华丽的分割线****************************/
@property(nonatomic,assign,readonly)CGRect picturesViewF;

@property(nonatomic,assign,readonly)CGRect retweetPicturesViewF;
/*****************华丽的分割线****************************/
@property(nonatomic,assign,readonly)CGRect bottomViewF;


@property(nonatomic,assign,readonly)CGFloat cellHeight;
@end
