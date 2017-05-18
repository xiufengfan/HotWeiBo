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
@end
