//
//  UIWindow+Extension.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "XFFNewfeatureViewController.h"
#import "XFFWelcomeViewController.h"
#import "XFFTabBarController.h"

@implementation UIWindow (Extension)
/**
 *  选择根控制器
 */
- (void)chooseRootviewController:(BOOL)isWelcome
{
    // 判断应用显示新特性还是欢迎界面
    // 1.获取沙盒中的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"CFBundleShortVersionString";
    NSString *sandboxVersion = [defaults objectForKey:key];
    
    // 2.获取软件当前的版本号
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = dict[key];
    
    // 3.比较沙盒中的版本号和软件当前的版本号
    if ([currentVersion compare: sandboxVersion] == NSOrderedDescending) {
        self.rootViewController = [[XFFNewfeatureViewController alloc]init];
        
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }else{
        if (isWelcome) {
            self.rootViewController = [[XFFWelcomeViewController alloc]init];
        }else
        {
            self.rootViewController = [[XFFTabBarController alloc]init];
        }
    }
}
@end
