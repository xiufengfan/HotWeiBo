//
//  XFFStatusTextView.m
//  HotWeiBo
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 XFF. All rights reserved.
//

#import "XFFStatusTextView.h"
#import "XFFTextPart.h"
@implementation XFFStatusTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.editable = NO;
        self.scrollEnabled = NO;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    NSArray *array = [self.attributedText attribute:@"specialParts" atIndex:0 effectiveRange:NULL];
    
    BOOL contains = NO;
    
    for (XFFTextPart *part in array) {
        
        self.selectedRange = part.range;
        
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        
        self.selectedRange = NSMakeRange(0, 0);
        for (UITextSelectionRect *selectionRect in rects) {
            if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) {
                continue;
            }
            
            if (CGRectContainsPoint(selectionRect.rect, point)) {
//                NSLog(@"点击了高亮范围");
                contains = YES;
                break;
            }
        }
        
        if (contains) {
            for (UITextSelectionRect *selectionRect in rects) {
                if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) {
                    continue;
                }
                
                UIView *cover = [[UIView alloc]init];
                cover.frame = selectionRect.rect;
                cover.backgroundColor = [UIColor purpleColor];
                cover.tag = 998;
                [self insertSubview:cover atIndex:0];
            }
            break;
        }
    }
    
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UIView *subView in self.subviews) {
        if (subView.tag == 998) {
            [subView removeFromSuperview];
        }
    }
}
@end
