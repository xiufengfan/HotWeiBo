//
//  XFFTextPart.h
//  HotWeiBo
//
//  Created by mac on 2017/6/14.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, XFFTextPartType) {
    XFFTextPartTypeEmotion,	// 表情
    XFFTextPartTypeTrend,		// 话题
    XFFTextPartTypeMention,		// @
    XFFTextPartTypeHref	// 超链接
};
@interface XFFTextPart : NSObject
/**
 *  正文的一部分
 */
@property (nonatomic, copy) NSString *text;
/**
 *  当前文本所在的范围
 */
@property (nonatomic, assign)  NSRange range;
/**
 *  是否是特殊字符串
 */
@property (nonatomic, assign) BOOL specail;
/**
 *  是否是表情
 */
@property (nonatomic, assign) BOOL emotion;

@property(nonatomic,assign)XFFTextPartType partType;

@end
