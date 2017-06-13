//
//  UIImage+XFF.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "UIImage+XFF.h"

@implementation UIImage (XFF)
+ (instancetype)resizableImageWithName:(NSString *)imageName
{
    /*
     // 1.创建图片
     UIImage *image = [UIImage imageWithName:imageName];
     // 2.处理图片
     image =  [image stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5];
     // 3.返回图片
     return image;
     */
    
    return [self resizableImageWithName:imageName leftRatio:0.5 topRatio:0.5];
    
    
}

+ (instancetype)resizableImageWithName:(NSString *)imageName leftRatio:(CGFloat)leftRatio topRatio:(CGFloat)topRatio
{
    // 1.创建图片
    UIImage *image = [UIImage imageNamed:imageName];
    // 2.处理图片
    CGFloat left = image.size.width * leftRatio;
    CGFloat top = image.size.height * topRatio;
    
    image =  [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
    //    [image stretchableImageWithLeftCapWidth:<#(NSInteger)#> topCapHeight:<#(NSInteger)#>]
    //    [image resizableImageWithCapInsets:<#(UIEdgeInsets)#>]
    //    [image resizableImageWithCapInsets:<#(UIEdgeInsets)#> resizingMode:<#(UIImageResizingMode)#>]
    // 3.返回图片
    return image;
}
@end
