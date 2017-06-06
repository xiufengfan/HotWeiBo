//
//  XFFNewfeatureViewController.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFNewfeatureViewController.h"
#import "XFFTabBarController.h"
@interface XFFNewfeatureViewController ()
- (IBAction)start;

@end

@implementation XFFNewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor redColor];
}


- (IBAction)start {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[XFFTabBarController alloc]init];
}
@end
