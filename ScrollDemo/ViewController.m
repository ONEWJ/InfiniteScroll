//
//  ViewController.m
//  ScrollDemo
//
//  Created by 王文娟 on 16/7/4.
//  Copyright © 2016年 EJU. All rights reserved.
//


#import "ViewController.h"
#import "TopCollectionView.h"
#import "InfiniteScrollView.h"
#import "TopTitleModel.h"
#import "TestViewController.h"
#define WJColor(R, G, B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
@interface ViewController ()<TopCollectionViewDelegate,InfiniteScrollViewDelegate>

@property (nonatomic, strong) NSArray *contentViewsArr;

@property (strong, nonatomic) NSArray<TopTitleModel *> *titleModels;

@property(nonatomic, weak) InfiniteScrollView * bodyScrollView;

@property(nonatomic, weak) TopCollectionView *topCollection;

@property(nonatomic, assign) NSInteger bodyIndex;

@end

@implementation ViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.titleModels = @[
                    
                    [TopTitleModel modelWithTitle:@"0-闸北大任湾中心"],
                    [TopTitleModel modelWithTitle:@"1-普陀友通中心"],
//
                    [TopTitleModel modelWithTitle:@"2-浦东龙阳大道中心"],
////
                    [TopTitleModel modelWithTitle:@"3-闵行"]
                    
                    ];
    
    for (TopTitleModel *model in self.titleModels) {
        model.selectedColor = WJColor(222, 90, 20);
        model.lineColor = WJColor(222, 90, 20);
        model.normalFont = [UIFont systemFontOfSize:12];
        model.selectedFont = [UIFont systemFontOfSize:14];
    }
    
    TopCollectionView *collection = [[TopCollectionView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    
    collection.backgroundColor = [UIColor blueColor];
    
    collection.scrollDelegate = self;
    
    collection.titleModels = self.titleModels;
    
    
    self.topCollection = collection;
    
    [self.view addSubview:collection];
    
//
    NSMutableArray *contentViewsDataArr = [NSMutableArray array];
    NSArray *colorArray = @[[UIColor redColor],[UIColor brownColor],[UIColor yellowColor],[UIColor greenColor]];
    for (NSInteger i = 0; i < colorArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = colorArray[i];
        
        [button setTitle:[NSString stringWithFormat:@"%zd",i] forState:UIControlStateNormal];
        
        
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [contentViewsDataArr addObject:button];
    }
    
    self.contentViewsArr = [NSArray arrayWithArray:contentViewsDataArr];
    
    InfiniteScrollView * scrollView = [[InfiniteScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80);
    _bodyScrollView = scrollView;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    [scrollView reloadDataAtIndex:self.bodyIndex];
    
}

-(void)click:(UIButton *)btn{
    
    [self presentViewController:[[TestViewController alloc]init] animated:YES completion:nil];

}

#pragma mark - TopCollectionViewDelegate

-(void)collectionView:(TopCollectionView *)collectionView didStopScrollAtIndex:(NSInteger )index{

    
    [self.bodyScrollView reloadDataAtIndex:index];
    
    self.bodyIndex = index;

}
-(void)collectionView:(TopCollectionView *)collectionView didSelectAtIndex:(NSInteger )index{
    
    if (index == self.bodyIndex) {
        return;
    }
    
    [self.bodyScrollView reloadDataAtIndex:index];
    
    self.bodyIndex = index;
    

}
#pragma mark - InfiniteLoopScrollView Delegate

- (NSInteger)numberOfContentViewsInInfiniteScrollView:(InfiniteScrollView *)infiniteScrollView{
    
    return self.contentViewsArr.count;
}

- (UIView *)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView contentViewAtIndex:(NSInteger)index{
    
    return self.contentViewsArr[index];
    
}

- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView scrollToPage:(NSInteger )page isNext:(BOOL )isNext{
    if (isNext) {
        [self.topCollection scrollToDirection:TopCollectionViewScrollDirectionRight];
    }else{
    
        [self.topCollection scrollToDirection:TopCollectionViewScrollDirectionLeft];
    }
    self.bodyIndex = page;

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.topCollection scrollToCurrentPage];

}


@end
