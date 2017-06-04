//
//  XFFEmotionAttachment.m
//  HotWeiBo
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFEmotionAttachment.h"
#import "XFFEmotion.h"
@implementation XFFEmotionAttachment
-(void)setEmotion:(XFFEmotion *)emotion
{
    _emotion = emotion;
    
    NSString *name = [NSString stringWithFormat:@"%@/%@",emotion.folder,emotion.png];
    self.image = [UIImage imageNamed:name];
}
@end
