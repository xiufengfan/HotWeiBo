//
//  XFFStatusRequest.h
//  HotWeiBo
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFFStatusRequest : NSObject
@property(nonatomic,copy)NSString *access_token;

@property(nonatomic,strong)NSNumber *since_id;

@property(nonatomic,strong)NSNumber *max_id;

@property(nonatomic,strong)NSNumber *count;
@end
