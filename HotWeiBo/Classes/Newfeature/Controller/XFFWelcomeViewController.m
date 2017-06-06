//
//  XFFWelcomeViewController.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFWelcomeViewController.h"
#import "UIImageView+WebCache.h"
#import "XFFAccountDao.h"
#import "XFFTabBarController.h"
@interface XFFWelcomeViewController ()

/**
 * 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/**
 * 欢迎标签
 */
@property (weak, nonatomic) IBOutlet UILabel *welcomLabel;

/**
 * 欢迎标签约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *welcomeLabelConstraint;

/**
 * 头像约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageViewConstraint;

@end

@implementation XFFWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:[XFFAccountDao account].profile_image_url];
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:1.0 animations:^{
        self.iconImageView.alpha = 1.0;
        self.iconImageViewConstraint.constant  -=  140;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.welcomLabel.alpha = 1.0;
//            self.welcomeLabelConstraint.constant = self.welcomeLabelConstraint.constant +100;
        } completion:^(BOOL finished) {
            UIWindow *window  = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[XFFTabBarController alloc]init];
        }];
    }];
}

@end
