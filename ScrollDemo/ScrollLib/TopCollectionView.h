//
//  TopCollectionView.h
//  ScrollDemo
//
//  Created by 王文娟 on 16/7/4.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TopCollectionViewScrollDirection){
    TopCollectionViewScrollDirectionLeft = 0,
    TopCollectionViewScrollDirectionRight   = 1
};

@class TopCollectionView,TopTitleModel;

@protocol TopCollectionViewDelegate <NSObject>

@optional

-(void)collectionView:(TopCollectionView *)collectionView didStopScrollAtIndex:(NSInteger )index;

-(void)collectionView:(TopCollectionView *)collectionView didSelectAtIndex:(NSInteger )index;
@end


@interface TopCollectionView : UICollectionView

@property(nonatomic, weak) id<TopCollectionViewDelegate> scrollDelegate;
/**
 *  左滑or右滑一格
 */
-(void)scrollToDirection:(TopCollectionViewScrollDirection )direction;

-(void)scrollToCurrentPage;

@property (nonatomic, strong) NSArray <TopTitleModel *> *titleModels;


@end
