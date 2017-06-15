//
//  XFFAccountService.m
//  HotWeiBo
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFAccountService.h"
#import "XFFNetworking.h"
#import "MJExtension.h"
@implementation XFFAccountService
+(void)accountWithParams:(XFFAccountRequest*)params success:(void(^)(XFFUser*result))success failure:(void(^)(NSError*error))failure
{
    [XFFNetworking GET:@"https://api.weibo.com/2/users/show.json" parameters:params.mj_keyValues success:^(id responseObject) {
        if (success) {
            XFFUser *user = [XFFUser mj_objectWithKeyValues:responseObject];
            success(user);
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
