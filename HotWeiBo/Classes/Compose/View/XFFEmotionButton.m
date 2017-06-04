//
//  XFFEmotionButton.m
//  HotWeiBo
//
//  Created by mac on 2017/6/2.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFEmotionButton.h"

@implementation XFFEmotionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
#pragma mark 只对image有效, 对background没有效果, 如果要取消background的高亮,重写setHighlighted:
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

-(void)setEmotion:(XFFEmotion *)emotion
{
    _emotion = emotion;
    NSString *name = [NSString stringWithFormat:@"%@/%@",emotion.folder,emotion.png];
    [self setImage:[UIImage imageNamed:name] forState:(UIControlStateNormal)];
}

@end
