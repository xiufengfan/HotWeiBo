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

@end
