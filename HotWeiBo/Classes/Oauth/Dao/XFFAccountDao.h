//
//  XFFAccountDao.h
//  HotWeiBo
//
//  Created by mac on 2017/5/17.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFFAccount.h"

@interface XFFAccountDao : NSObject

+(void)save:(XFFAccount*)account;

+(XFFAccount*)account;

@end
