//
//  NSDate+Extension.h
//  HotWeiBo
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 * 是否为今天
 */
-(BOOL)isToday;
/**
 * 是否为今天
 */
-(BOOL)isTomorrow;
/**
 * 是否为昨天
 */
-(BOOL)isYesterday;
/**
 * 是否为今年
 */
-(BOOL)isThisYear;

-(NSDateComponents*)componentsTo:(NSDate*)date;
@end
