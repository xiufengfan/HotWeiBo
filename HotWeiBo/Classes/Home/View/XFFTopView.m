//
//  XFFTopView.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFTopView.h"
#import "XFFStatusFrame.h"
#import "XFFOriginalView.h"
#import "XFFRetweetView.h"

@interface XFFTopView ()
@property(nonatomic,weak)XFFOriginalView *originalView;

@property(nonatomic,weak)XFFRetweetView*retweetView;

@end
@implementation XFFTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        XFFOriginalView *originalView = [[XFFOriginalView alloc]init];
        [self addSubview:originalView];
        self.originalView = originalView;
        
        XFFRetweetView *retweetView = [[XFFRetweetView alloc]init];
        retweetView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:retweetView];
        self.retweetView = retweetView;
    }
    return self;
}

-(void)setStatusFrame:(XFFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    self.frame = _statusFrame.topViewF;
    
    self.originalView.statusFrame = _statusFrame;

    self.retweetView.statusFrame = _statusFrame;
}


@end
