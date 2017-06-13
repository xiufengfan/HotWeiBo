//
//  XFFStatus.h
//  HotWeiBo
//
//  Created by mac on 2017/5/17.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XFFUser;
@interface XFFStatus : NSObject
/*微博字符串id*/
@property(nonatomic,copy)NSString *idstr;

/*微博信息内容*/
@property(nonatomic,copy)NSString *text;

/*微博来源*/
@property(nonatomic,copy)NSString *source;

/*微博创建时间*/
@property(nonatomic,copy)NSString *created_at;

/*微博作者的用户信息*/
@property(nonatomic,strong)XFFUser *user;

@property(nonatomic,strong)NSArray *pic_urls;

/**
 *  转发微博
 */
@property (nonatomic, strong) XFFStatus *retweeted_status;

/**
 *  赞数
 */
@property (nonatomic, strong) NSNumber *attitudes_count;
/**
 *  评论数
 */
@property (nonatomic, strong) NSNumber *comments_count;
@end
