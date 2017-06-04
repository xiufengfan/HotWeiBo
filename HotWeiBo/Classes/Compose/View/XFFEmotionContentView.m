//
//  XFFEmotionContentView.m
//  HotWeiBo
//
//  Created by mac on 2017/6/1.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFEmotionContentView.h"
#import "XFFEmotion.h"
#import "XFFEmotionButton.h"
static const NSUInteger XFFMaxCols = 7;
static const NSUInteger XFFMaxRows = 3;
static const NSUInteger XFFPageSize = XFFMaxRows * XFFMaxCols - 1;


@interface XFFEmotionContentView()<UIScrollViewDelegate>
@property(nonatomic,weak)UIScrollView*scrollView;
@property(nonatomic,weak)UIPageControl*pageControl;
@property(nonatomic,weak)UIView*divider;
@end
@implementation XFFEmotionContentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化scrollview
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        // 隐藏滚动条
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        // 使用KVC设置pageControl的圆点图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        UIView *divider = [[UIView alloc]init];
        divider.backgroundColor = [UIColor grayColor];
        divider.alpha = 0.5;
        [self addSubview:divider];
        self.divider = divider;
    }
    return self;
}

-(void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 添加按钮
    NSUInteger count = emotions.count;
    for (NSUInteger i = 0; i< count; i++) {
        XFFEmotionButton *emotionButton  = [[XFFEmotionButton alloc]init];
         emotionButton.emotion = emotions[i];
        [emotionButton addTarget:self action:@selector(emotionButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.scrollView addSubview:emotionButton];
    }
    // 计算页数
    self.pageControl.numberOfPages = (count + XFFPageSize - 1) / XFFPageSize;
    
    // 添加删除按钮
    for (NSUInteger i = 0; i<self.pageControl.numberOfPages; i++) {
        UIButton *deleteButton = [[UIButton alloc]init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:(UIControlStateNormal)];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:(UIControlStateHighlighted)];
        
        [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.scrollView addSubview:deleteButton];
    }
}

-(void)emotionButtonClick:(XFFEmotionButton*)emotionButton
{
    NSDictionary *userInfo = @{XFFClickedEmotion:emotionButton.emotion};
     [[NSNotificationCenter defaultCenter]postNotificationName:XFFEmotionButtonDidClickNotification object:nil userInfo:userInfo];
}
-(void)deleteButtonClick:(UIButton*)deleteButton
{
    [[NSNotificationCenter defaultCenter]postNotificationName:XFFDeleteButtonDidClickNotification object:nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.y = self.height - self.pageControl.height;
    
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.pageControl.numberOfPages, 0);
    
    // 表情布局
    CGFloat leftMargin = 15;
    CGFloat topMargin = 15;
    CGFloat buttonW = (self.scrollView.width - 2 *leftMargin) / XFFMaxCols;
    CGFloat buttonH = (self.scrollView.height - topMargin) / XFFMaxRows;
    
    NSUInteger count = self.scrollView.subviews.count - self.pageControl.numberOfPages;
    for (NSUInteger i = 0; i<count; i++) {
        XFFEmotionButton *emotionButton = self.scrollView.subviews[i];
        emotionButton.width = buttonW;
        emotionButton.height = buttonH;
        
        // 页码号
        NSUInteger pageNo = i / XFFPageSize;
        // 最后的索引
        NSUInteger index = i + pageNo;
        // 行号
        NSUInteger row = index / XFFMaxCols;
        // 列号
        NSUInteger col = index % XFFMaxCols;
        
        emotionButton.x = leftMargin + col * buttonW + pageNo * self.scrollView.width;
        emotionButton.y = topMargin + row * buttonH - pageNo * (3 * buttonH);
    }
    
    self.divider.height = 1;
    self.divider.width = self.width;
    
    
    // 删除按钮
    
    for (NSUInteger i = count; i<self.scrollView.subviews.count; i++) {
        UIButton *deleteButton = self.scrollView.subviews[i];
        deleteButton.width = buttonW;
        deleteButton.height = buttonH;
        
        if (count == i) {
            deleteButton.x = self.scrollView.width - leftMargin - buttonW;
        }else
        {
            UIButton *lastButton = self.scrollView.subviews[i-1];
            deleteButton.x = lastButton.x + self.scrollView.width;
        }
        deleteButton.y = self.scrollView.height - buttonH;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

@end
