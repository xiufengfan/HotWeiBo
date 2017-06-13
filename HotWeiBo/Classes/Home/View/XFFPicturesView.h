//
//  XFFPicturesView.h
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFFPicturesView : UIView
@property(nonatomic,strong)NSArray *pic_urls;
+ (CGSize)sizeWithPhotoCount:(NSUInteger)photoCount;
@end
