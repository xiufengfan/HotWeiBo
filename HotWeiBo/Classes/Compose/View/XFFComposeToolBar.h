//
//  XFFComposeToolBar.h
//  HotWeiBo
//
//  Created by mac on 2017/6/4.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFFComposeToolBar;
typedef enum {
    XFFComposeToolbarButtonTypeCamera, // 拍照
    XFFComposeToolbarButtonTypePicture, // 相册
    XFFComposeToolbarButtonTypeMention, // @
    XFFComposeToolbarButtonTypeTrend, // #
    XFFComposeToolbarButtonTypeEmotion // 表情
}XFFComposeToolbarButtonType;


@protocol XFFComposeToolBarDelegate<NSObject>
@optional
-(void)composeToolBar:(XFFComposeToolBar*)composeToolBar dicButtonClick:(XFFComposeToolbarButtonType)type;
@end

@interface XFFComposeToolBar : UIView
@property(nonatomic,weak)id<XFFComposeToolBarDelegate> delegate;
-(void)switchEmotion:(BOOL)isEmotion;
@end
