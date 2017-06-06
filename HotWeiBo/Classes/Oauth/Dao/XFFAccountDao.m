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
//    XFFLog(@"%@",XFFAccountPath);
    [NSKeyedArchiver archiveRootObject:account toFile:XFFAccountPath];
}

+(XFFAccount*)account{
    XFFAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:XFFAccountPath];
//    XFFLog(@"%@",account.expires_time);
    return [[NSDate date] compare:account.expires_time] == NSOrderedAscending ? account : nil;
}
@end
