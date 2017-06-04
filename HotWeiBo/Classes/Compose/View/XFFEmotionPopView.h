//
//  XFFEmotionPopView.h
//  HotWeiBo
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFFEmotionButton;
@interface XFFEmotionPopView : UIView
+(instancetype)popView;

/**
 * 从某个表情按钮上面弹出
 */
- (void)popFromEmotionButton:(XFFEmotionButton *)emotionButton;
@end
