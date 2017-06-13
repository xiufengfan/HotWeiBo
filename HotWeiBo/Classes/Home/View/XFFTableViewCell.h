//
//  XFFTableViewCell.h
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFFStatusFrame;
@interface XFFTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView;

#warning 注意, 变量名不要和系统自带的属性重名, 不然会引发一些未知的bug
@property(nonatomic,strong)XFFStatusFrame *statusFrame;
@end
