//
//  XFFComposeViewController.m
//  HotWeiBo
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFComposeViewController.h"
#import "XFFAccountDao.h"
#import "XFFTextArea.h"
#import "AFNetworking.h"
#import "XFFBarHUD.h"
#import "XFFEmotionKeyboard.h"
#import "XFFEmotionButton.h"
#import "XFFEmotionTextArea.h"

@interface XFFComposeViewController ()<UITextViewDelegate>
@property(nonatomic,weak)XFFEmotionTextArea *area;
@end

@implementation XFFComposeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    
    [self setupTextArea];
}

-(void)setupTextArea{
    XFFEmotionTextArea *area = [[XFFEmotionTextArea alloc]init];
    area.frame = self.view.bounds;
    area.placehold = @"分享新鲜事...";
    area.font = [UIFont systemFontOfSize:17];
    area.delegate = self;
    [self.view addSubview:area];
    self.area = area;
    
    XFFEmotionKeyboard *keyboard = [[XFFEmotionKeyboard alloc]init];
    keyboard.height = 216;
    area.inputView = keyboard;
    


    // 监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionButtonClick:) name:XFFEmotionButtonDidClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteButtonClick) name:XFFDeleteButtonDidClickNotification object:nil];
}

-(void)emotionButtonClick:(NSNotification*)note
{
    [self.area insertEmotion:note.userInfo[XFFClickedEmotion]];
}

-(void)deleteButtonClick
{
     [self.area deleteBackward];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setupNav{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:(UIControlStateNormal)];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:(UIControlStateDisabled)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancle)];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:(UIBarButtonItemStyleDone) target:self action:@selector(send)];
    
    // 设置标题
    NSString *prefix = @"发微博";
    NSString *name = [XFFAccountDao account].name;
    
    if (name) {
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.height = 44;
        self.navigationItem.titleView = label;
        
        NSString *text = [NSString stringWithFormat:@"%@\n%@",prefix,name];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:text];
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, prefix.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[text rangeOfString:name]];
        
        
        // 图文混排
        //        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
        //        [string appendAttributedString:[[NSAttributedString alloc]initWithString:prefix]];
        //
        //        NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
        //        attachment.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
        //        [string appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        //
        //        [string appendAttributedString:[[NSAttributedString alloc]initWithString:@"哈哈"]];
        
        
        label.attributedText = string;
        
    }else{
        self.title = prefix;
    }
}


-(void)cancle{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send{
    [self cancle];
    
      [XFFBarHUD showLoading:@"发布中..."];
      [XFFBarHUD showSuccess:@"发布中成功"];
     

#warning 新浪微博发送微博是高级服务，此处无法发送成功
    /*
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XFFAccountDao account].access_token;
    params[@"status"] = self.area.emotionText;
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        
        [XFFBarHUD showSuccess:@"发布成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络繁忙，请重试"];
    }];
    */
    
}

#pragma mark - <UITextViewDelegate>

-(void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

@end
