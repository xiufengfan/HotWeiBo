//
//  NSString+Date.m
//  HotWeiBo
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "NSString+Date.h"
#import "NSDate+Extension.h"

@implementation NSString (Date)
+(NSString*)stringWithDate:(NSDate*)date
{
    NSString *showString;
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if(date.isThisYear){
        NSDateComponents *cmt = [date componentsTo:now];
        if(date.isToday){
            if(cmt.hour >=1){
                showString = [NSString stringWithFormat:@"%ld小时以前",cmt.hour];
            }else if(cmt.minute>=1){
                showString = [NSString stringWithFormat:@"%ld分钟以前",cmt.minute];
            }else{
                showString = @"刚刚";
            }
        }else if(date.isYesterday){
            formatter.dateFormat = @"昨天 HH:mm";
            showString = [formatter stringFromDate:date];
        }else{
            formatter.dateFormat = @"MM-dd HH:mm";
            showString = [formatter stringFromDate:date];
        }
    }else{
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        showString = [formatter stringFromDate:date];
    }
    return  showString;
}
@end
