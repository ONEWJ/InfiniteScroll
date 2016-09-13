//
//  TopTitleModel.h
//  ScrollDemo
//
//  Created by 王文娟 on 16/7/5.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopTitleModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIColor *lineColor;


@property (nonatomic, assign, getter=isSelected) BOOL select;
@property (nonatomic, assign, getter=isShowLineWhenSelected) BOOL showLineWhenSelect;


-(instancetype )initWithTitle:(NSString *)title;
+(instancetype )modelWithTitle:(NSString *)title;
@end
