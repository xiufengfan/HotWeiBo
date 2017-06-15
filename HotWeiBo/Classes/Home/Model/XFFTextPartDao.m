//
//  XFFTextPartDao.m
//  HotWeiBo
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFTextPartDao.h"
#import "RegexKitLite.h"
#import "XFFTextPart.h"

@implementation XFFTextPartDao
+(NSArray*)specailsWithPattern:(NSString*)pattern text:(NSString*)text
{
    // 定义数字记录字符串中所有的碎片
    NSMutableArray *specails = [NSMutableArray array];
    
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        XFFTextPart *part = [[XFFTextPart alloc]init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.specail = YES;
        [specails addObject:part];
    }];
    
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        XFFTextPart *part = [[XFFTextPart alloc]init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.specail = NO;
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
