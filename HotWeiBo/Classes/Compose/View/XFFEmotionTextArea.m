//
//  XFFEmotionTextArea.m
//  HotWeiBo
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFEmotionTextArea.h"
#import "XFFEmotion.h"
#import "XFFEmotionAttachment.h"
@implementation XFFEmotionTextArea

/**
 * 将表情插入到当前光标的位置
 */
- (void)insertEmotion:(XFFEmotion *)emotion
{
    // 生成一个带图片的属性文字
    XFFEmotionAttachment *attachment = [[XFFEmotionAttachment alloc]init];
    attachment.emotion = emotion;
    CGFloat imgWH = self.font.lineHeight;
    attachment.bounds = CGRectMake(0, -4, imgWH, imgWH);
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 生成属性文字
    NSUInteger oldLoc = self.selectedRange.location;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
    
    [string appendAttributedString:self.attributedText];
    
    [string replaceCharactersInRange:self.selectedRange withAttributedString:imageString];
    
    [string addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, string.length)];
    
    
#pragma mark 一旦重新设置了文字,光标会自动定位到文字最后面
    self.attributedText = string;
    
    // 设置光标
    self.selectedRange = NSMakeRange(oldLoc+1, 0);
}

/**
 * 返回带有表情描述的文字, 比如"[发红包]999[马到成功]"
 */
- (NSString *)emotionText
{
    NSMutableString *text = [[NSMutableString alloc]init];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        XFFEmotionAttachment * attachment = attrs[@"NSTextAttachment"];
        if (attachment) {
            [text appendString:attachment.emotion.chs];
        }else
        {
            NSAttributedString *attribtedString = [self.attributedText attributedSubstringFromRange:range];
            [text appendString:attribtedString.string];
        }
    }];
    return text;
}

@end
