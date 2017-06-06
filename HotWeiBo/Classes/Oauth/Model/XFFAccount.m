//
//  XFFAccount.m
//  HotWeiBo
//
//  Created by mac on 2017/5/17.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFAccount.h"
#import "MJExtension.h"
@implementation XFFAccount
MJCodingImplementation
+(instancetype)accountWithDictionary:(NSDictionary *)dict
{
    
    XFFAccount *account = [[self alloc]init];
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.uid = dict[@"uid"];
    account.name = dict[@"name"];
    account.profile_image_url = dict[@"profile_image_url"];
    // 过期时间不用重复计算
    account.expires_time = [[NSDate date] dateByAddingTimeInterval:[account.expires_in doubleValue]];
    return account;
}
@end
