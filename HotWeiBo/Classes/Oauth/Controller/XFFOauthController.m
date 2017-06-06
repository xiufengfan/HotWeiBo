//
//  XFFOauthController.m
//  HotWeiBo
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFOauthController.h"
#import "XFFNetworking.h"
#import "XFFTabBarController.h"
#import "XFFAccountDao.h"
#import "MBProgressHUD+MJ.h"

//#define APPKEY @"658366130"
//#define REDIRECT_URI @"http://www.baidu.com"
//#define APPSECRET @"966bb57464f198ed67cc97c88c5978b8"
//#define CODE @"983f15b626c36da9216cb0e7f0eeca15"
//#define ACCESS_TOKEN @"2.00h4iGTD0YG8Yif887cf6622cUBNOD"



@interface XFFOauthController ()<UIWebViewDelegate>
@property(nonatomic,weak)UIWebView *webView;
@end

@implementation XFFOauthController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSString*urlString = @"https://api.weibo.com/oauth2/authorize?client_id=658366130&redirect_uri=http://www.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [webView loadRequest:request];
}


#pragma mark UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * urlString = request.URL.absoluteString;
    NSRange range = [urlString rangeOfString:@"code="];
    if(range.location == NSNotFound  || range.length == 0){
        return YES;
    }else{
        NSString *code = [urlString substringFromIndex:range.location + range.length ];
        XFFLog(@"code=%@",code);
        [self accessTokenWithCode:code];
        return NO;
    }
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    XFFLog(@"webViewDidStartLoad");
    [MBProgressHUD showHUDAddedTo:webView animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    XFFLog(@"webViewDidFinishLoad");
    [MBProgressHUD hideHUDForView:webView animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    XFFLog(@"didFailLoadWithError");
    [MBProgressHUD hideHUDForView:webView animated:YES];
}


-(void)accessTokenWithCode:(NSString*)code{
    /*
     client_id	true	string	申请应用时分配的AppKey。
     client_secret	true	string	申请应用时分配的AppSecret。
     grant_type	true	string	请求的类型，填写authorization_code，grant_type为authorization_code时
     必选	类型及范围	说明
     code	true	string	调用authorize获得的code值。
     redirect_uri
     */

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"658366130";
    params[@"client_secret"] = @"966bb57464f198ed67cc97c88c5978b8";
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = @"http://www.baidu.com";
    
    [XFFNetworking post:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(id responseObject) {
        XFFLog(@"%@",responseObject);
        XFFAccount *account = [XFFAccount accountWithDictionary:responseObject];
        [XFFAccountDao save:account];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[XFFTabBarController alloc]init];
    } failure:^(NSError *error) {
        XFFLog(@"%@",error);
    }];
}
@end
