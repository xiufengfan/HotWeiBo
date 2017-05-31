//
//  XFFLoadMoreFooter.m
//  HotWeiBo
//
//  Created by mac on 2017/5/20.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFLoadMoreFooter.h"

@implementation XFFLoadMoreFooter

+(instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XFFLoadMoreFooter" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}
@end
