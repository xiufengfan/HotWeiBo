//
//  XFFComposePhotosView.m
//  HotWeiBo
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFComposePhotosView.h"

@implementation XFFComposePhotosView

/**
 * 增加图片
 */
- (void)addImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    [self addSubview:imageView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int maxCols = 3;
    CGFloat leftRightMargin = 10;
    CGFloat imageMargin = 15;
    CGFloat imageW = (self.width - 2 * leftRightMargin - (maxCols - 1 ) * imageMargin) / maxCols;
    CGFloat imageH = imageW;
    NSUInteger count = self.subviews.count;
    for (NSUInteger i = 0; i<count; i++) {
        UIImageView *imageView = self.subviews[i];
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = leftRightMargin + (i % maxCols) * (imageW + imageMargin);
        imageView.y = (i / maxCols) * (imageH + imageMargin);
    }
    
}

/**
 * 取出显示的所有图片
 */
- (NSArray *)images
{
    return [self.subviews valueForKeyPath:@"image"];
}

@end
