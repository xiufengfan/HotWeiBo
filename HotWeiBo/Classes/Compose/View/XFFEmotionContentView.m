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
#import "XFFEmotionPopView.h"
#import "XFFEmotionDao.h"

@interface XFFEmotionContentView()<UIScrollViewDelegate>
@property(nonatomic,weak)UIScrollView*scrollView;
@property(nonatomic,weak)UIPageControl*pageControl;
@property(nonatomic,weak)UIView*divider;

@property(nonatomic,weak)XFFEmotionPopView*popView;
@end
@implementation XFFEmotionContentView

-(XFFEmotionPopView*)popView
{
    if (!_popView) {
        _popView = [XFFEmotionPopView popView];
    }
    return _popView;
}

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
        
        // 添加手势
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}


/**
 * 在表情上面长按并且滑动
 */
-(void)drag:(UILongPressGestureRecognizer*)recognizer
{
    // 手势所在的位置
    CGPoint loc = [recognizer locationInView:recognizer.view];
    
    // 手指位置所在的表情按钮
    XFFEmotionButton *emotionButton = [self emotionButtonForLoc:loc];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self.popView removeFromSuperview];
            if (emotionButton == nil) return;
            [self postEmotionNote:emotionButton];
        }
            break;
        default:
            if (emotionButton == nil)  return;
            [self.popView popFromEmotionButton:emotionButton];
            break;
    }
}

-(XFFEmotionButton*)emotionButtonForLoc:(CGPoint)loc
{
    for (XFFEmotionButton*emotionButton in self.scrollView.subviews) {
        if (![emotionButton isKindOfClass:[XFFEmotionButton class]]) continue;
        // 让按钮的x值减去一定个数的屏幕宽度
        CGRect frame = emotionButton.frame;
        frame.origin.x = frame.origin.x - self.pageControl.currentPage * self.scrollView.width;
        
#warning  判断传入的点是否在frame内
        if (CGRectContainsPoint(frame, loc)) {
            return emotionButton;
        }
    }
    return nil;
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
    // 布局子控件
#warning 添加完子控件后马上刷新布局
    [self setNeedsLayout];
}

-(void)emotionButtonClick:(XFFEmotionButton*)emotionButton
{
    [self postEmotionNote:emotionButton];
    
    // 在按钮上显示一个放大镜
    [self.popView popFromEmotionButton:emotionButton];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
}

-(void)postEmotionNote:(XFFEmotionButton*)emotionButton
{
    [XFFEmotionDao addRecentEmotin:emotionButton.emotion];
    
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
