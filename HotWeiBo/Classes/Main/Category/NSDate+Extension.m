//
//  NSDate+Extension.m
//  HotWeiBo
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
-(BOOL)isToday{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmt= [calendar components:(NSCalendarUnitDay) fromDate:self.ymd toDate:[[NSDate date] ymd] options:0];
    return  cmt.day == 0;
}

-(BOOL)isTomorrow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmt= [calendar components:(NSCalendarUnitDay) fromDate:self.ymd toDate:[[NSDate date] ymd] options:0];
    return cmt.day == -1;
}
-(BOOL)isYesterday{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmt= [calendar components:(NSCalendarUnitDay) fromDate:self.ymd toDate:[[NSDate date] ymd] options:0];
    return cmt.day == 1;
}
-(BOOL)isThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmt = [calendar components:(NSCalendarUnitYear) fromDate:self.ymd toDate:[NSDate date].ymd options:0];
    return  cmt.year ==0;
}

-(NSDateComponents *)componentsTo:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmt = [calendar components:(unit) fromDate:self toDate:date options:0];
    return cmt;
}
-(NSDate*)ymd{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return  [formatter dateFromString:[formatter stringFromDate:self]];
}
@end
