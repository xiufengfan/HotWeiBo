//
//  XFFAccountService.h
//  HotWeiBo
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFFAccountRequest.h"
#import "XFFUser.h"
@interface XFFAccountService : NSObject
+(void)accountWithParams:(XFFAccountRequest*)params success:(void(^)(XFFUser*result))success failure:(void(^)(NSError*error))failure;
@end
