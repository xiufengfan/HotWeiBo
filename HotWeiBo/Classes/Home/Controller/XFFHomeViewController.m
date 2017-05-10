//
//  XFFHomeViewController.m
//  HotWeiBo
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFHomeViewController.h"
#import "XFFTitleButton.h"
@interface XFFHomeViewController ()

@end

@implementation XFFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBackgroundImage:@"navigationbar_pop" highlightedImage:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBackgroundImage:@"navigationbar_friendsearch" highlightedImage:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendsearch)];
    
    XFFTitleButton *titleBtn  = [[XFFTitleButton alloc]init];
    [titleBtn setTitle:@"首页" forState:(UIControlStateNormal)];
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:(UIControlStateNormal)];
    self.navigationItem.titleView = titleBtn;
    
}

-(void)pop{
    XFFLog(@"pop");
}

-(void)friendsearch{
    XFFLog(@"friendsearch");
    XFFTitleButton *titleBtn = (XFFTitleButton*)self.navigationItem.titleView;
    [titleBtn setTitle:@"哈哈哈哈" forState:(UIControlStateNormal)];
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
