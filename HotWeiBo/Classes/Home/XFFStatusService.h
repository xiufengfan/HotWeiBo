//
//  XFFStatusService.h
//  HotWeiBo
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFFStatusRequest.h"
#import "XFFHomeStatusResult.h"
#import "XFFStatus.h"
@interface XFFStatusService : NSObject
+(void)statusWithParams:(XFFStatusRequest*)params success:(void(^)(XFFHomeStatusResult* result))success failure:(void(^)(NSError*error))failure;
@end
