//
//  XFFHomeStatusResult.m
//  HotWeiBo
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFHomeStatusResult.h"
#import "MJExtension.h"
#import "XFFStatus.h"
@implementation XFFHomeStatusResult

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"statuses":[XFFStatus class]};
}
@end
