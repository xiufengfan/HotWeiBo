//
//  XFFTextPart.m
//  HotWeiBo
//
//  Created by mac on 2017/6/14.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFTextPart.h"

@implementation XFFTextPart
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.text, NSStringFromRange(self.range)];
}

@end
