//
//  XFFTableViewCell.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFTableViewCell.h"
#import "XFFStatusFrame.h"
#import "XFFBottomView.h"
#import "XFFTopView.h"
@interface XFFTableViewCell( )
@property(nonatomic,weak)XFFTopView *topView;
@property(nonatomic,weak)XFFBottomView*bottomView;
@end


@implementation XFFTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"statusCell";
    XFFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupTopView];
        [self setupBottomView];
    }
    return self;
}

-(void)setupTopView
{
    XFFTopView *topView = [[XFFTopView alloc]init];
    [self.contentView addSubview:topView];
    self.topView = topView;
}

-(void)setupBottomView
{
    XFFBottomView *bottomView = [[XFFBottomView alloc]init];
    
    [self.contentView addSubview:bottomView];
    self.bottomView  = bottomView;
}

-(void)setStatusFrame:(XFFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    self.topView.statusFrame = _statusFrame;
    
    self.bottomView.statusFrame = _statusFrame;
}
@end
