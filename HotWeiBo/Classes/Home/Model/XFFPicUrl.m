//
//  XFFPicUrl.m
//  HotWeiBo
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFPicUrl.h"

@implementation XFFPicUrl

-(void)setThumbnail_pic:(NSString *)thumbnail_pic
{
    _thumbnail_pic = [thumbnail_pic copy];
    self.bmiddle_pic = [thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
}

@end
