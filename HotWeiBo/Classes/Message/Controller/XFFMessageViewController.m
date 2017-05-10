//
//  XFFMessageViewController.m
//  HotWeiBo
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFMessageViewController.h"
#import "XFFTitleButton.h"
@interface XFFMessageViewController ()

@end

@implementation XFFMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    XFFTitleButton *titleBtn = [[XFFTitleButton alloc]init];
    [titleBtn setTitle:@"消息" forState:(UIControlStateNormal)];
    self.navigationItem.titleView = titleBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
