//
//  XFFTabBarController.m
//  HotWeiBo
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFTabBarController.h"
#import "XFFProfileViewController.h"
#import "XFFHomeViewController.h"
#import "XFFMessageViewController.h"
#import "XFFDiscoverViewController.h"

@interface XFFTabBarController ()

@end

@implementation XFFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XFFHomeViewController *homeVc = [[XFFHomeViewController alloc]init];
    [self addOncChildController:homeVc title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    
    XFFDiscoverViewController *discoverVc = [[XFFDiscoverViewController alloc]init];
    [self addOncChildController:discoverVc title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    XFFMessageViewController *messageVc = [[XFFMessageViewController alloc]init];
    [self addOncChildController:messageVc title:@"消息" imageName:@"tabbar_message" selectedImageName:@"tabbar_message_selected"];
    
    XFFProfileViewController *profileVc = [[XFFProfileViewController alloc]init];
    [self addOncChildController:profileVc title:@"我的" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    
//    [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


-(void)addOncChildController:(UIViewController*)vc title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName{
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:(UIControlStateSelected)];
    vc.view.backgroundColor = XFFRandomColor;
    vc.tabBarItem.title = title;
    [vc.tabBarItem setImage:[UIImage imageNamed:imageName]];
    [vc.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImageName]];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}


-(void)addOneChildController:(Class)className title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName{
    UIViewController *vc = [[className alloc]init];
    [self addOncChildController:vc title:title imageName:imageName selectedImageName:selectedImageName];
}

-(void)addOneChildController:(UIViewController*)vc nav:(UINavigationController*)nav title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName{
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:(UIControlStateSelected)];
    vc.view.backgroundColor = XFFRandomColor;
    vc.tabBarItem.title = title;
    [vc.tabBarItem setImage:[UIImage imageNamed:imageName]];
    [vc.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImageName]];
    [self addChildViewController:nav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
