//
//  XFFStatusService.m
//  HotWeiBo
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFStatusService.h"
#import "XFFNetworking.h"
#import "MJExtension.h"
@implementation XFFStatusService
+(void)statusWithParams:(XFFStatusRequest*)params success:(void(^)(XFFHomeStatusResult* result))success failure:(void(^)(NSError*error))failure
{
//    if (本地缓存数据) {
//        
//    }else{
   [XFFNetworking GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params.mj_keyValues success:^(id responseObject) {
       if (success) {
           XFFHomeStatusResult *result = [XFFHomeStatusResult mj_objectWithKeyValues:responseObject];
           success(result);
       }
   } failure:^(NSError *error) {
       if (failure) {
           failure(error);
       }
   }];
//    }
}
@end
