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
#import "XFFNetworking.h"
#import "XFFBarHUD.h"
#import "XFFEmotionKeyboard.h"
#import "XFFEmotionButton.h"
#import "XFFEmotionTextArea.h"
#import "XFFComposeToolBar.h"
#import "QBImagePickerController.h"
#import "XFFComposePhotosView.h"
#import "XFFBarHUD.h"
@interface XFFComposeViewController ()<UITextViewDelegate,XFFComposeToolBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate>
@property(nonatomic,weak)XFFEmotionTextArea *area;
@property(nonatomic,strong)XFFComposePhotosView*photosView;
@property(nonatomic,strong)XFFEmotionKeyboard *keyboard;

@property(nonatomic,weak)XFFComposeToolBar*toolBar;
@property(nonatomic,weak)XFFComposeToolBar*tempToolBar;
@end

@implementation XFFComposeViewController

-(XFFComposePhotosView *)photosView
{
    if (!_photosView) {
        _photosView = [[XFFComposePhotosView alloc]init];
        self.photosView.y = 100;
        self.photosView.width = self.view.width;
        self.photosView.height = self.view.height;
        [self.area addSubview:self.photosView];
    }
    return _photosView;
}

-(XFFEmotionKeyboard *)keyboard
{
    if (!_keyboard) {
        _keyboard = [[XFFEmotionKeyboard alloc]init];
        _keyboard.height = 216;
    }
    return _keyboard;
}

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
    area.alwaysBounceVertical = YES;
    area.delegate = self;
    [self.view addSubview:area];
    self.area = area;
    
    XFFComposeToolBar *toolBar = [[XFFComposeToolBar alloc]init];
    toolBar.height = 44;
    toolBar.delegate = self;
    self.area.inputAccessoryView = toolBar;
    self.toolBar =toolBar;
    
    XFFComposeToolBar *tempToolBar = [[XFFComposeToolBar alloc]init];
    tempToolBar.height = toolBar.height;
    tempToolBar.y = self.view.height - tempToolBar.height;
    tempToolBar.width = self.view.width;
    tempToolBar.x = 0;
    tempToolBar.delegate = self;
    [self.view addSubview:tempToolBar];
    self.tempToolBar = tempToolBar;
    
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XFFAccountDao account].access_token;
    params[@"status"] = self.area.emotionText;
//    [self sendStatus:manager params:params];
 
}


/**
 发送无图片微博
 */
-(void)sendStatus:(NSDictionary*)params
{
    [XFFNetworking post:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(id responseObject) {
        [XFFBarHUD showSuccess:@"发布成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络繁忙，请重试"];
    }];
}


/**
 发送有图片的微博
 */
-(void)sendStatusWithImages:(NSDictionary*)params
{
    [XFFNetworking post:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [self.photosView.images firstObject];
        NSData *data = UIImagePNGRepresentation(image);
#warning 这里文件名称命名和处理没有做
        [formData appendPartWithFileData:data name:@"pic" fileName:@"1.jpg" mimeType:@"image/jpeg"];
    } success:^(id responseObject) {
        [XFFBarHUD  showSuccess:@"发送成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络繁忙，请重试"];
    }];
}

#pragma mark - <UITextViewDelegate>

-(void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.area resignFirstResponder];
}

#pragma mark - <XFFComposeToolBarDelegate>
/*
 XFFComposeToolbarButtonTypeCamera, // 拍照
 XFFComposeToolbarButtonTypePicture, // 相册
 XFFComposeToolbarButtonTypeMention, // @
 XFFComposeToolbarButtonTypeTrend, // #
 XFFComposeToolbarButtonTypeEmotion // 表情
 */
-(void)composeToolBar:(XFFComposeToolBar *)composeToolBar dicButtonClick:(XFFComposeToolbarButtonType)type
{
    switch (type) {
        case XFFComposeToolbarButtonTypeCamera:
            [self openCamera];
            break;
        case XFFComposeToolbarButtonTypePicture:
            [self openPicture];
            break;
        case XFFComposeToolbarButtonTypeMention:
            XFFLog(@"@");
            break;
        case XFFComposeToolbarButtonTypeTrend:
            XFFLog(@"#");
            break;
        case XFFComposeToolbarButtonTypeEmotion:
            [self switchKeyborad];
            break;
    }
}


/**
 * 打开照相机
 */
-(void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc .delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 * 打开相册
 */
-(void)openPicture
{
    NSUInteger count = self.photosView.images.count;
    NSUInteger maxNum  =9 ;
    if (count == maxNum) {
        [XFFBarHUD showError:@"已经添加了9张图片了"];
    }else
    {
        QBImagePickerController *ipc = [[QBImagePickerController alloc]init];
        ipc.delegate = self;
        ipc.allowsMultipleSelection = YES;
        ipc.limitsMaximumNumberOfSelection = YES;
        ipc.maximumNumberOfSelection = maxNum - count;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ipc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}


/**
 * 切换键盘
 */
-(void)switchKeyborad
{
    [self.area resignFirstResponder];
    if (self.area.inputView){
        self.area.inputView = nil;
        [self.toolBar switchEmotion:YES];
        [self.tempToolBar switchEmotion:YES];
    }else
    {
        self.area.inputView = self.keyboard;
        [self.toolBar switchEmotion:NO];
        [self.tempToolBar switchEmotion:NO];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.area becomeFirstResponder];
    });
}
#pragma mark - QBImagePickerControllerDelegate
-(void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    // 关闭控制器
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    for (NSDictionary *dic in info) {
        [self.photosView addImage:dic[UIImagePickerControllerOriginalImage]];
    }
}
-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    // 关闭控制器
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}
@end
