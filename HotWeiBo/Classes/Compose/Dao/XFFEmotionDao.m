//
//  XFFEmotionDao.m
//  HotWeiBo
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFEmotionDao.h"
#import "MJExtension.h"
#import "XFFEmotion.h"

@implementation XFFEmotionDao
static NSArray *_defaultEmotions;
static NSArray *_recentEmotions;
static NSArray *_lxhEmotions;
/**
 *  默认的表情数据(数组里面装的都是模型, XFFEmotion)
 */
+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        _defaultEmotions = [XFFEmotion mj_objectArrayWithFilename:@"default/info.plist"];
#pragma mark 创建文件夹路径
         [_defaultEmotions makeObjectsPerformSelector:@selector(setFolder:) withObject:@"default"];
    }
    return _defaultEmotions;
}
/**
 *  最近的表情数据(数组里面装的都是模型, XFFEmotion)
 */
+ (NSArray *)recentEmotions
{
#warning TODO
    return nil;
}
/**
 *  浪小花的表情数据(数组里面装的都是模型, XFFEmotion)
 */
+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        _lxhEmotions = [XFFEmotion mj_objectArrayWithFilename:@"lxh/info.plist"];
#pragma mark 创建文件夹路径
        [_lxhEmotions makeObjectsPerformSelector:@selector(setFolder:) withObject:@"lxh"];
    }
    return _lxhEmotions;
}
@end
