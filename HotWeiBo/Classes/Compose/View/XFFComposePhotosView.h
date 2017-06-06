//
//  XFFComposePhotosView.h
//  HotWeiBo
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFFComposePhotosView : UIView
/**
 * 增加图片
 */
- (void)addImage:(UIImage *)image;
/**
 * 取出显示的所有图片
 */
- (NSArray *)images;
@end
