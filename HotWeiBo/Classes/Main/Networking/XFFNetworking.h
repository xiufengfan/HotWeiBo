//
//  XFFNetworking.h
//  HotWeiBo
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface XFFNetworking : NSObject
/**
 * 上传文件的post的方法
 */
 +(void)post:(NSString *)URLString
                             parameters:(id)parameters
              constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>  formData))block
                                success:( void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;

/**
 * post 方法
 */
+(void)post:(NSString *)URLString
 parameters:(id)parameters
    success:( void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;


/**
 * get方法
 */
+ (void)GET:(NSString *)URLString
                            parameters:(id)parameters
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;


/**
 * head方法
 */
+ ( void )head:(NSString *)URLString
                             parameters:(id)parameters
                                success:(void (^)( ))success
                                failure:( void (^)(NSError *error))failure;


/**
 * delete方法
 */
+ (void)DELETE:(NSString *)URLString
                               parameters:(id)parameters
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;
/**
 * patch方法
 */
+ (void)PATCH:(NSString *)URLString
                              parameters:(id)parameters
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
/**
 * put方法
 */
+ (void)PUT:(NSString *)URLString
                            parameters:(id)parameters
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
@end
