//
//  XFFStatus.m
//  HotWeiBo
//
//  Created by mac on 2017/5/17.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFStatus.h"
#import "MJExtension.h"
#import "XFFPicUrl.h"
#import "NSString+Date.h"
#import "XFFUser.h"
#import "XFFTextPart.h"
#import "RegexKitLite.h"
#import "XFFEmotion.h"
#import "XFFEmotionDao.h"
#define XFFStatusTextFont [UIFont systemFontOfSize:16]

@implementation XFFStatus
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"pic_urls":[XFFPicUrl class]};
}

-(void)setSource:(NSString *)source
{
    if(source.length){
        NSUInteger loc = [source rangeOfString:@">"].location + 1;
        NSUInteger len = [source rangeOfString:@"<" options:(NSBackwardsSearch)].location - loc;
        _source = [source substringWithRange:NSMakeRange(loc, len)];
    }else{
        _source = @"新浪微博";
    }
}

-(void)setCreated_at:(NSString *)created_at
{
    /*
     1.今年
        1）今天
            1>1分钟内 ：刚刚
            2>1小时内 ：x分钟前
            3>其他    ：x小时前
        2）非今天
            昨天 09：08
        3）其他
            5-5 09:08
     2.非今年
     2012年-09-07 09：08
     */
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [formatter dateFromString:created_at];
    _created_at = [NSString stringWithDate:date];
}

-(void)setText:(NSString *)text
{
    _text = [text copy];
    
    self.attributedText = [self attributedStringWithText:text];
}

-(void)setRetweeted_status:(XFFStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;
    
      NSString *newStr = [NSString stringWithFormat:@"@%@:%@", _retweeted_status.user.name, _retweeted_status.text];
    
    self.retweetedAttributedText = [self attributedStringWithText:newStr];
}

/**
 *  根据普通字符串生成带属性的字符串
 *
 *  @param text 普通字符串
 *
 *  @return 带属性的字符串
 */
- (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    // 利用正则表达式匹配所有的 用户昵称/话题/URL
    // 匹配表情
    NSString *emotionPattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    // 匹配发送微博的人
    NSString *atPattern = @"@\\w+(-)?\\w+:"; // ^以什么开头 $以什么结尾
    // 匹配话题
    NSString *trendPattern = @"#\\w+#";
    // URL
    NSString *urlPattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    
    // 可以使用|符号将多个规则连接在一起, 让正则表达表达式同时匹配多个规则
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, trendPattern, atPattern, urlPattern];
    
    // 定义数字记录字符串中所有的碎片
    NSArray *specails = [self  specailsWithPattern:pattern text:text];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    
    NSMutableArray *specialParts = [NSMutableArray array];
    /*
    for (XFFTextPart *part in specails) {
        if (part.partType ==XFFTextPartTypeEmotion ) {
                // 1.根据当前表情描述获取对应的表情模型
                XFFEmotion *emotion = [XFFEmotionDao emotionWithchs:part.text];
                // 2.拼接表情图片名称
                NSString *imageName = [NSString stringWithFormat:@"%@/%@", emotion.folder, emotion.png];
                // 3.创建附件
                // 当前碎片是表情
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed:imageName];
                attachment.bounds = CGRectMake(0, -3, 16, 16);
            
            // 将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attachment];
            [str appendAttributedString:attachString];
            }
            else
            {
               NSMutableAttributedString* temp = [[NSMutableAttributedString alloc] initWithString:part.text];
                [part.text enumerateStringsMatchedByRegex:trendPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                    [temp addAttribute:NSForegroundColorAttributeName value:XFFStatusHighTextColor range:*capturedRanges];
                    [temp addAttribute:XFFLinkText value:*capturedStrings range:*capturedRanges];
                    
                    [specialParts addObject:part];
                }];
          
                [part.text enumerateStringsMatchedByRegex:atPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                    [temp addAttribute:NSForegroundColorAttributeName value:XFFStatusHighTextColor range:*capturedRanges];
                    [temp addAttribute:XFFLinkText value:*capturedStrings range:*capturedRanges];
                    [specialParts addObject:part];
                }];
          
                [part.text enumerateStringsMatchedByRegex:urlPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                    [temp addAttribute:NSForegroundColorAttributeName value:XFFStatusHighTextColor range:*capturedRanges];
                    [temp addAttribute:XFFLinkText value:*capturedStrings range:*capturedRanges];
                    [specialParts addObject:part];
                }];
                
                [str appendAttributedString:temp];
        }
    }
     */
    for (XFFTextPart *part in specails)
    {
        NSMutableAttributedString *temp = nil;
        if (part.emotion) {
            //            NSLog(@"%@", part.text);
            
            // 1.根据当前表情描述获取对应的表情模型
            XFFEmotion *emotion = [XFFEmotionDao emotionWithchs:part.text];
            // 2.拼接表情图片名称
            NSString *imageName = [NSString stringWithFormat:@"%@/%@", emotion.folder, emotion.png];
            // 3.创建附件
            // 当前碎片是表情
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage imageNamed:imageName];
            attachment.bounds = CGRectMake(0, -3, 16, 16);
            NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:attachment];
            [temp appendAttributedString:attributedString];
        }else if (part.specail)
        {
            // 当前碎片是特殊字符串
            temp = [[NSMutableAttributedString alloc] initWithString:part.text attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
            
            // 添加特殊字符串模型到数组中, 方便以后使用
            [specialParts addObject:part];
        }else
            
        {
            // 当前碎片是普通字符串
            temp = [[NSMutableAttributedString alloc] initWithString:part.text];
            
        }
        [str appendAttributedString:temp];
    }
#warning 如果想要通过属性字符串计算字符串的size, 在计算之前必须先设置字符串的字体大小, 如果不设置, 计算出来的值会不正确
    // 设置字体
    [str addAttribute:NSFontAttributeName value:XFFStatusTextFont range:NSMakeRange(0, str.length)];
    // 将特殊字符串数组绑定到属性字符串
    [str addAttribute:@"specialParts" value:specialParts range:NSMakeRange(0, 1)];

    return str;
}

/**
 *  保存表情和非表情碎片
 *
 *  @param text 普通字符串
 *
 *  @return 碎片有序数组
 */
-(NSArray*)specailsWithPattern:(NSString*)pattern text:(NSString*)text
{
    // 定义数字记录字符串中所有的碎片
    NSMutableArray *specails = [NSMutableArray array];
    
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        XFFTextPart *part = [[XFFTextPart alloc]init];
        part.specail = YES;
        if ([part.text hasPrefix:@"["] &&
            [part.text hasSuffix:@"]"]) {
            // 是表情
            part.emotion = YES;
        }
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [specails addObject:part];
    }];
    
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        XFFTextPart *part = [[XFFTextPart alloc]init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [specails addObject:part];
    }];
    
    [specails sortUsingComparator:^NSComparisonResult(XFFTextPart *obj1, XFFTextPart *obj2) {
        if (obj1.range.location > obj2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    return specails;
}

/**
 *  保存碎片
 *
 *  @param text 普通字符串
 *
 *  @return 碎片有序数组
 */
-(NSArray*)specailsWithPattern:(NSString*)pattern text:(NSString*)text partType:(XFFTextPartType)partType
{
    // 定义数字记录字符串中所有的碎片
    NSMutableArray *specails = [NSMutableArray array];
    
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        XFFTextPart *part = [[XFFTextPart alloc]init];
        part.partType = partType;
        if ([part.text hasPrefix:@"["] &&
            [part.text hasSuffix:@"]"]) {
            // 是表情
            part.emotion = YES;
        }
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [specails addObject:part];
    }];
    
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        XFFTextPart *part = [[XFFTextPart alloc]init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.specail = YES;
        [specails addObject:part];
    }];
    
    [specails sortUsingComparator:^NSComparisonResult(XFFTextPart *obj1, XFFTextPart *obj2) {
        if (obj1.range.location > obj2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    return specails;
}

@end
