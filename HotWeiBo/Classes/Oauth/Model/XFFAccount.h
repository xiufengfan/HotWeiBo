//
//  XFFAccount.h
//  HotWeiBo
//
//  Created by mac on 2017/5/17.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "access_token" = "2.00h4iGTD0YG8Yif887cf6622cUBNOD";
 "expires_in" = 157679999;
 "remind_in" = 157679999;
 uid = 3178512813;
 }
 */
@interface XFFAccount : NSObject<NSCoding>
@property(nonatomic,copy)NSString *access_token;
@property(nonatomic,copy)NSString *expires_in;
@property(nonatomic,strong)NSDate *expires_time;
@property(nonatomic,copy)NSString *uid;

+(instancetype)accountWithDictionary:(NSDictionary*)dict;
@end
