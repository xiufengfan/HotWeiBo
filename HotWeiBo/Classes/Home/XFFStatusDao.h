//
//  XFFStatusDao.h
//  HotWeiBo
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XFFStatusRequest;
@interface XFFStatusDao : NSObject

/**
 *  保存传入的微博对象
 *
 *  @param dict 需要保存的微博对象
 *
 *  @return 是否保存成功
 */
+(BOOL)saveStatuses:(NSDictionary*)dict;

+(NSArray*)getStatusWithRequest:(XFFStatusRequest*)request;
@end
