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

#define XFFRecentFile  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recent_emotions.data"]

@implementation XFFEmotionDao
static NSArray *_defaultEmotions;
static NSMutableArray *_recentEmotions;
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
    if (!_recentEmotions) {
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:XFFRecentFile];
        if (!_recentEmotions) {
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
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

/**
 * 加载最近使用的表情
 */
+(void)addRecentEmotin:(XFFEmotion*)emotion
{
    // 获取已保存的表情
    [self recentEmotions];
    // 删除之前存在的表情
    [_recentEmotions removeObject:emotion];
    
    [_recentEmotions insertObject:emotion atIndex:0];
    
    if (_recentEmotions.count > XFFPageSize) {
        [_recentEmotions removeObjectAtIndex:XFFPageSize];
    }

#pragma mark 如果要持久化就要考虑持久化对象是否实现NSCopying协议
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:XFFRecentFile];
    
}

+ (XFFEmotion *)emotionWithchs:(NSString *)chs
{
    NSArray *defaultEmotions = [self defaultEmotions];
    for (XFFEmotion *emotion in defaultEmotions) {
        if ([chs isEqualToString:emotion.chs]) {
            return emotion;
        }
    }
    
    NSArray *lxhEmotions = [self lxhEmotions];
    for (XFFEmotion *emotion in lxhEmotions) {
        if ([chs isEqualToString:emotion.chs]) {
            return emotion;
        }
    }
    return nil;
}
@end
