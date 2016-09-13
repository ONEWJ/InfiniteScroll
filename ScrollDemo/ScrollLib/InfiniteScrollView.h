//
//  InfiniteScrollView.h
//  ScrollDemo
//
//  Created by 王文娟 on 16/7/5.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfiniteScrollView;

@protocol InfiniteScrollViewDelegate <NSObject>

@required

- (NSInteger)numberOfContentViewsInInfiniteScrollView:(InfiniteScrollView *)infiniteScrollView;

- (UIView *)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView contentViewAtIndex:(NSInteger)index;

@optional

/**
 *   *  滚动到下一页或者前一页
 *
 *  @param infiniteScrollView self
 *  @param page               当前页
 *  @param isNext             如果值是NO表示前一页
 */
- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView scrollToPage:(NSInteger )page isNext:(BOOL )isNext;

@end




@interface InfiniteScrollView : UIView

@property (nonatomic,assign) id<InfiniteScrollViewDelegate> delegate;

-(void)reloadDataAtIndex:(NSInteger )page;

@end
