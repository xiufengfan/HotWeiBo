//
//  XFFPicturesView.m
//  HotWeiBo
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFPicturesView.h"
#import "XFFImageView.h"
#import "XFFPhotoBrower.h"
#import "XFFPicUrl.h"
#import "UIView+ViewController.h"

#define XFFPictureMargin 10 // 间隙
#define XFFPictureWidth 70  // 配图宽度
#define  XFFPictureHeight XFFPictureWidth

@interface XFFPicturesView ()<MWPhotoBrowserDelegate>
@property(nonatomic,strong) NSMutableArray *photos;

@end
@implementation XFFPicturesView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < 9; i++) {
            XFFImageView *imageView = [[XFFImageView alloc]init];
            imageView.backgroundColor = [UIColor redColor];
            imageView.tag = i ;
            imageView.userInteractionEnabled = YES;
            imageView.hidden = YES;
            [self addSubview:imageView];
            
            
            UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
            [imageView addGestureRecognizer:recognizer];
        }
    }
    return self;
}

-(void)imageTap:(UITapGestureRecognizer*)recognizer
{
    //创建MWPhotoBrowser ，要使用initWithDelegate方法，要遵循MWPhotoBrowserDelegate协议
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    //设置当前要显示的图片
    [browser setCurrentPhotoIndex:recognizer.view.tag];
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated: YES];
    browser.title = @"图片浏览器";
    
    NSMutableArray *photos = [NSMutableArray array];
    NSUInteger count = self.pic_urls.count;
    for (NSUInteger i = 0; i<count; i++) {
        XFFPicUrl *picUrl = self.pic_urls[i];
        MWPhoto *photo = [[MWPhoto alloc]initWithURL:[NSURL URLWithString:picUrl.bmiddle_pic]];
        [photos addObject:photo];
    }
    self.photos = photos;
    
    
    //push到MWPhotoBrowser
    [[XFFPicturesView getCurrentViewController:self].navigationController pushViewController:browser animated:YES];
}


-(void)setPic_urls:(NSArray *)pic_urls
{
    _pic_urls = pic_urls;
    if (_pic_urls.count > 0) {
        self.hidden = NO;
    }else
    {
        self.hidden = YES;
    }
#warning 注意, 由于cell会被重用, 所以可能前一次的cell有9张配图, 但是重用之后的cell没有9张配图, 可能只有1~8张, 但是由于上一次有9张, 所以9张配图的hidden状态都是NO, 所以被重用时需要把不需要显示的配图hidden设置为YES, 但是我们这个地方遍历的时候, 是以传入的配图数量作为最大值, 所以不能完全遍历9张图片, 所以每次都必须遍历9张图片, 将所有图片的状态重新设置一次
    
    for(int i = 0;i < 9;i++){
        XFFImageView *imageView = self.subviews[i];
        if (i<_pic_urls.count) {
            imageView.hidden = NO;
            imageView.pic_url = _pic_urls[i];
        }else
        {
            imageView.hidden = YES;
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    for (NSUInteger i = 0; i<count; i++) {
        // 行号
        NSUInteger row = i / 3;
        // 列号
        NSUInteger col = i % 3;
        // X = 列号 * （宽度 + 间隙）
        CGFloat imageX = col * (XFFPictureMargin + XFFPictureWidth);
        // Y = 行号 * （高度 + 间隙）
        CGFloat imageY = row * (XFFPictureMargin + XFFPictureHeight);
        
        XFFImageView *imageView = self.subviews[i];
        imageView.frame = CGRectMake(imageX, imageY, XFFPictureWidth, XFFPictureHeight);
    }
}
+ (CGSize)sizeWithPhotoCount:(NSUInteger)photoCount
{
    // 列数
    NSUInteger col = photoCount > 3 ? 3 : photoCount;
    // 行数
    NSUInteger row = 0;
    // 6 3 9
    if (photoCount % 3 == 0) {

        row = photoCount / 3; // 2 1 3
    }else
    {
        // 2 5
        row = photoCount / 3 + 1; // 1 2
    }
    
    // 宽度 = 列数 * 配图的宽度 + (列数 - 1) * 间隙
    CGFloat width = col * XFFPictureWidth + (col - 1) * XFFPictureMargin;
    // 高度 = 行数 * 配图的高度 + (行数 - 1) * 间隙
    CGFloat heigth = row * XFFPictureHeight + (row - 1) * XFFPictureMargin;
    
    return CGSizeMake(width, heigth);
}
#pragma mark - <MWPhotoBrowserDelegate>
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return self.photos[index];
}
@end
