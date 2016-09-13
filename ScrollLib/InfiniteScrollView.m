//
//  InfiniteScrollView.m
//  ScrollDemo
//
//  Created by 王文娟 on 16/7/5.
//  Copyright © 2016年 EJU. All rights reserved.
//
#import "InfiniteScrollView.h"

#define SEFT_WIDTH     (self.frame.size.width)
#define SEFT_HEIGHT    (self.frame.size.height)

@interface InfiniteScrollView () <UIScrollViewDelegate>{
    
    UIScrollView   * _scrollView;
    NSInteger        _pageCount;
    NSInteger        _currentPage;
}
@end

@implementation InfiniteScrollView


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _scrollView = [[UIScrollView alloc] init];
        
        _scrollView.pagingEnabled = YES;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_scrollView];
    }
    
    return self;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _scrollView.frame = CGRectMake(0, 0, SEFT_WIDTH, SEFT_HEIGHT);
    
    if (_pageCount==1) {
        
        _scrollView.contentSize = CGSizeMake(0, SEFT_HEIGHT);
        
        _scrollView.contentOffset = CGPointMake(0, 0);
        
    }else{
        
        _scrollView.contentSize = CGSizeMake(SEFT_WIDTH *3, SEFT_HEIGHT);
        
        _scrollView.contentOffset = CGPointMake(SEFT_WIDTH, 0);
    }
    
    //代理不要放在initWithFrame中
     _scrollView.delegate = self;
}


-(void)reloadDataAtIndex:(NSInteger )page{
    
    _currentPage = page;
    
    if ([self.delegate respondsToSelector:@selector(numberOfContentViewsInInfiniteScrollView:)]) {
        
        _pageCount = [self.delegate numberOfContentViewsInInfiniteScrollView:self];
        
         [self resetContentViews];
        
    }else{
        NSAssert(NO, @"请实现numberOfContentViewsInInfiniteScrollView:");
    }
    
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsetX = scrollView.contentOffset.x;
    
    if(contentOffsetX >= (2 * SEFT_WIDTH)) {//右移
        
        _currentPage = [self getNextPageIndexWithCurrentPageIndex:_currentPage];
        
        if ([self.delegate respondsToSelector:@selector(infiniteScrollView:scrollToPage:isNext:)]) {
            
            [self.delegate infiniteScrollView:self scrollToPage:_currentPage isNext:YES];
            
        }
        
        [self resetContentViews];
    }
    
    
    if(contentOffsetX <= 0) {//左移
        
        _currentPage = [self getPreviousPageIndexWithCurrentPageIndex:_currentPage];
        
        if ([self.delegate respondsToSelector:@selector(infiniteScrollView:scrollToPage:isNext:)]) {
            [self.delegate infiniteScrollView:self scrollToPage:_currentPage isNext:NO];
        }
        
        [self resetContentViews];
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [scrollView setContentOffset:CGPointMake(SEFT_WIDTH, 0) animated:YES];
}

#pragma mark - method

- (void)resetContentViews{
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(_pageCount == 0) return;
    
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:contentViewAtIndex:)]) {
        
        
        if (_pageCount == 1) {
            
            UIView* currentContentView = [self.delegate infiniteScrollView:self contentViewAtIndex:_currentPage];
            
            currentContentView.frame = CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
            
            [_scrollView addSubview:currentContentView];
            
            [_scrollView setContentOffset:CGPointMake(0, 0)];
            
        }else{
            
            UIView *previousContentView = [self.delegate infiniteScrollView:self contentViewAtIndex:[self getPreviousPageIndexWithCurrentPageIndex:_currentPage]];
            
            if (_pageCount == 2) {
                
                 previousContentView = [self duplicate:previousContentView];
            }
            
            UIView *currentContentView = [self.delegate infiniteScrollView:self contentViewAtIndex:_currentPage];
            
            UIView *nextContentView = [self.delegate infiniteScrollView:self contentViewAtIndex:[self getNextPageIndexWithCurrentPageIndex:_currentPage]];
            
            NSArray *viewsArr = @[previousContentView,currentContentView,nextContentView];
            
            for (int i = 0; i < viewsArr.count; i++) {
                
                UIView * contentView = viewsArr[i];
                
                [contentView setFrame:CGRectMake(SEFT_WIDTH*i, 0,self.frame.size.width, self.frame.size.height)];
                
                [_scrollView addSubview:contentView];
            }
            
            [_scrollView setContentOffset:CGPointMake(SEFT_WIDTH, 0)];
            
        }
        
    }else{
        NSAssert(NO, @"请实现infiniteScrollView:contentViewAtIndex:");
    }
}

/**
 *   拷贝的View不能接收事件，这里只是用做视觉展示，等真正滑动到当前页面的时候，当前界面已经是原始的View了，所以又可以接收事件了
 */
- (UIView *)duplicate:(UIView*)view{
    
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (NSInteger)getPreviousPageIndexWithCurrentPageIndex:(NSInteger)currentIndex{
    
    if (currentIndex == 0) {
        
        return _pageCount -1;
        
    }else{
        
        return currentIndex -1;
    }
}

- (NSInteger)getNextPageIndexWithCurrentPageIndex:(NSInteger)currentIndex{
    
    if (currentIndex == _pageCount -1) {
        
        return 0;
        
    }else{
        
        return currentIndex +1;
    }
}


@end
