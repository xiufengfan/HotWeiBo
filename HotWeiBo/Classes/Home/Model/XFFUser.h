//
//  XFFUser.h
//  HotWeiBo
//
//  Created by mac on 2017/5/17.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFFUser : NSObject

@property(nonatomic,copy)NSString *ID;
/*友好显示名称*/
@property(nonatomic,copy)NSString *name;

/*用户头像地址（中图），50×50像素*/
@property(nonatomic,copy)NSString *profile_image_url;

@property (nonatomic, copy) NSString *gender;

/**
 *  会员等级
 */
@property (nonatomic, assign) int mbrank;
/**
 *  会员类型
 */
@property (nonatomic, assign) int mbtype;

/**
 *  判断是否是会员 , YES是会员
 */
@property (nonatomic, assign, getter=isVip) BOOL vip;
@end
