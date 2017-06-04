//
//  XFFEmotionDao.h
//  HotWeiBo
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFFEmotionDao : NSObject

/**
 *  默认的表情数据(数组里面装的都是模型, XFFEmotion)
 */
+ (NSArray *)defaultEmotions;
/**
 *  最近的表情数据(数组里面装的都是模型, XFFEmotion)
 */
+ (NSArray *)recentEmotions;
/**
 *  浪小花的表情数据(数组里面装的都是模型, XFFEmotion)
 */
+ (NSArray *)lxhEmotions;
@end
