//
//  XFFTextArea.m
//  HotWeiBo
//
//  Created by mac on 2017/5/31.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFTextArea.h"

@implementation XFFTextArea
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setNeedsDisplay) name:UITextViewTextDidChangeNotification object:self];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setPlacehold:(NSString *)placehold
{
    _placehold = [placehold copy];
    
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];

    [self setNeedsDisplay];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    if (self.hasText) return;
    
    // 文字属性
    NSMutableDictionary *atts = [NSMutableDictionary dictionary];
    atts[NSForegroundColorAttributeName] = [UIColor grayColor];
    if(self.font){
        atts[NSFontAttributeName] = self.font;
    }
    // 画文字
    CGRect placeholderRect;
    
    placeholderRect.origin = CGPointMake(5, 7);
    
    CGFloat w = rect.size.width - 2 * placeholderRect.origin.x;
    CGFloat h = rect.size.height - 2 * placeholderRect.origin.y;
    placeholderRect.size = CGSizeMake(w, h);
    
    [self.placehold drawInRect:placeholderRect withAttributes:atts];
}

@end
