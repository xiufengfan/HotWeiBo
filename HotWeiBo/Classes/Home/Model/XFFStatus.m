//
//  XFFStatus.m
//  HotWeiBo
//
//  Created by mac on 2017/5/17.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFStatus.h"
#import "MJExtension.h"
#import "XFFPicUrl.h"
@implementation XFFStatus
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"pic_urls":[XFFPicUrl class]};
}

-(void)setSource:(NSString *)source
{
    if(source.length){
        NSUInteger loc = [source rangeOfString:@">"].location + 1;
        NSUInteger len = [source rangeOfString:@"<" options:(NSBackwardsSearch)].location - loc;
        _source = [source substringWithRange:NSMakeRange(loc, len)];
    }else{
        _source = @"新浪微博";
    }
    
}
@end
