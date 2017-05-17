//
//  XFFAccountDao.m
//  HotWeiBo
//
//  Created by mac on 2017/5/17.
//  Copyright © 2017年 XFF. All rights reserved.
//
// 账号存储路径
#define XFFAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#import "XFFAccountDao.h"

@implementation XFFAccountDao
+(void)save:(XFFAccount*)account;
{
    account.expires_time = [[NSDate date] dateByAddingTimeInterval:[account.expires_in doubleValue]];
    [NSKeyedArchiver archiveRootObject:account toFile:XFFAccountPath];
}

+(XFFAccount*)account{
    XFFAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:XFFAccountPath];
    return [[NSDate date] compare:account.expires_time] == NSOrderedAscending ? nil :account;
}
@end
