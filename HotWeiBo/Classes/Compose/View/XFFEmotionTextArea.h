//
//  XFFEmotionTextArea.h
//  HotWeiBo
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFTextArea.h"
@class XFFEmotion;
@interface XFFEmotionTextArea : XFFTextArea
/**
 * 将表情插入到当前光标的位置
 */
- (void)insertEmotion:(XFFEmotion *)emotion;

/**
 * 返回带有表情描述的文字, 比如"[发红包]999[马到成功]"
 */
- (NSString *)emotionText;
@end
