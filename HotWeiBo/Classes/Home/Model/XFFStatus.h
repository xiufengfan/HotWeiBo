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
/*微博信息内容*/
@property(nonatomic,copy)NSString *text;

/*微博来源*/
@property(nonatomic,copy)NSString *source;

/*微博创建时间*/
@property(nonatomic,copy)NSString *created_at;

/*微博作者的用户信息*/
@property(nonatomic,strong)XFFUser *user;

@property(nonatomic,strong)NSArray *pic_urls;
@end
