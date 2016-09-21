//
//  TopCollectionView.m
//  ScrollDemo
//
//  Created by 王文娟 on 16/7/4.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import "TopCollectionView.h"
#import "TopTitleModel.h"

/********************************     CircleLayout   ************************************/

typedef void(^CircleLayoutFinalScrollIndexPath)(NSIndexPath *indexPath);

@interface CircleLayout : UICollectionViewFlowLayout

@property(nonatomic, copy) CircleLayoutFinalScrollIndexPath finalScrollIndexPath ;

@end

@implementation CircleLayout

-(void)prepareLayout{
    
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    CGRect rect = (CGRect){proposedContentOffset.x,0,self.collectionView.frame.size};
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDelta = MAXFLOAT;
    
    NSIndexPath *minIndexppath = nil;
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
            
            minIndexppath = attrs.indexPath;
        }
    }
    
    proposedContentOffset.x += minDelta;
    
    if (self.finalScrollIndexPath) {
        self.finalScrollIndexPath(minIndexppath);
    }
    
    return proposedContentOffset;
}
@end


/********************************     TopTitleCollectionCell   ************************************/

@interface TopTitleCollectionCell : UICollectionViewCell
@property (nonatomic, strong) TopTitleModel *titleModel;
@property (nonatomic, weak) UIButton *titleButton;
@property (nonatomic, weak) UIView *line;
@end
@implementation TopTitleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIButton *titleButton = [[UIButton alloc]init];
        
        titleButton.enabled = NO;
        
//        label.textAlignment = NSTextAlignmentCenter;
        
        _titleButton = titleButton;
        
        [self.contentView addSubview:titleButton];
        
        UIView *line = [[UIView alloc]init];
        
        line.hidden = YES;
        
        _line = line;
        
        [self.contentView addSubview:line];
        
    }
    return self;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.titleButton.frame = self.bounds;
    
}

-(void)setTitleModel:(TopTitleModel *)titleModel{
    
    _titleModel = titleModel;
    
    if (titleModel.showLineWhenSelect && titleModel.isSelected) {
        
        self.line.hidden = NO;
        
        self.line.backgroundColor = titleModel.lineColor;
        
    }else{
        
        self.line.hidden = YES;
        
    }
    
    if (titleModel.isSelected) {
        
        [self.titleButton setTitleColor:titleModel.selectedColor forState:UIControlStateNormal];
        
        self.titleButton.titleLabel.font = titleModel.selectedFont;
        
//        self.label.textColor = titleModel.selectedColor;
//        
//        self.label.font = titleModel.selectedFont;
        
    }else{
        
        [self.titleButton setTitleColor:titleModel.normalColor forState:UIControlStateNormal];
        
        self.titleButton.titleLabel.font = titleModel.normalFont;

        
//        self.label.textColor = titleModel.normalColor;
//        
//        self.label.font = titleModel.normalFont;
        
    }
    
    [self.titleButton setTitle:titleModel.title forState:UIControlStateNormal];
    
    if (titleModel.leftIconName && titleModel.leftIconName.length) {
        
        [self.titleButton setImage:[UIImage imageNamed:titleModel.leftIconName] forState:UIControlStateNormal];
        
    }else{
    
        [self.titleButton setImage:nil forState:UIControlStateNormal];

    }
    
//    CGSize size = [self.titleButton.title sizeWithAttributes:@{NSFontAttributeName:self.label.font}];
    
    CGFloat width = self.frame.size.width;
    
//    CGFloat width = size.width +5;
    
    if (!self.line.hidden) {
        
        self.line.frame = CGRectMake((self.frame.size.width - width)/2.0, self.frame.size.height - 5, width, 2);
    }
    
    
}

@end

/********************************     TopCollectionView   ************************************/

static NSString *cellID = @"cellID";

@interface TopCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) CircleLayout *layout;
@property(nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation TopCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.dataSource = self;
        
        self.delegate = self;
        
        CircleLayout *layout = [[CircleLayout alloc]init];
        
        __weak typeof (self) weakSelf = self;
        
        layout.finalScrollIndexPath = ^(NSIndexPath *indexPath){
            
            if ([weakSelf.scrollDelegate respondsToSelector:@selector(collectionView:didStopScrollAtIndex:)]) {
                
                weakSelf.currentPage = indexPath.row;
                
            }
        
        };
        
        self.layout = layout;
        
        self.collectionViewLayout = layout;
        
        layout.minimumLineSpacing = 0;
        
        [self registerClass:[TopTitleCollectionCell class] forCellWithReuseIdentifier:cellID];

    }
    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.titleModels.count ==1) {
        return CGSizeMake(self.frame.size.width, self.frame.size.height);
    }
    return CGSizeMake(self.frame.size.width*3/7.0, self.frame.size.height);
}



-(void)setTitleModels:(NSArray<TopTitleModel *> *)titleModels{
    
    _titleModels = titleModels;
    
    if (!titleModels.count) {
        return;
    }

    NSInteger scrollIndex = INT16_MAX/2;
    
    NSInteger index = INT16_MAX/2;
    
    for (NSInteger i = 0; i<self.titleModels.count; i++) {
        
        if (index%self.titleModels.count == 0) {
            
            scrollIndex = index;
            
            break;
            
        }else{
            
            index++;
            
        }
        
    }
    
    self.currentPage = scrollIndex;
    
    if (titleModels.count==1) {
        self.currentPage = 0;
    }
    
    
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self reloadData];


}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (!self.titleModels.count) {
        return;
    }
    
    self.selectedIndex = self.currentPage%self.titleModels.count;
    
    [self.scrollDelegate collectionView:self didStopScrollAtIndex:self.currentPage%self.titleModels.count];
    
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (!self.titleModels.count) {
        return 0;
    }
    
    if (self.titleModels.count == 1) {
        return 1;
    }
    
    return INT16_MAX;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TopTitleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    TopTitleModel *model = self.titleModels[indexPath.row%self.titleModels.count];
    
    model.select = self.selectedIndex == (indexPath.row%self.titleModels.count);
    
    cell.titleModel = model;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.scrollDelegate respondsToSelector:@selector(collectionView:didSelectAtIndex:)]) {
        [self.scrollDelegate collectionView:self didSelectAtIndex:indexPath.row%self.titleModels.count];
    }
    
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.selectedIndex = indexPath.row%self.titleModels.count;
    
    self.currentPage = indexPath.row;
    
    [self reloadData];
    
}

-(void)scrollToDirection:(TopCollectionViewScrollDirection )direction{
    
    if (!self.titleModels.count) {
        return;
    }
    
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:self.currentPage - 1 inSection:0];
    
    if (direction == TopCollectionViewScrollDirectionRight) {
        
        indexP = [NSIndexPath indexPathForRow:self.currentPage + 1 inSection:0];
    }

    [self scrollToItemAtIndexPath:indexP atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    self.selectedIndex = indexP.row%self.titleModels.count;
    
    self.currentPage = indexP.row;
    
    [self reloadData];

}
-(void)scrollToCurrentPage{
    
    if (!self.titleModels.count){
        return;
    }
    
    [self scrollViewDidEndDecelerating:self];
    
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
@end
