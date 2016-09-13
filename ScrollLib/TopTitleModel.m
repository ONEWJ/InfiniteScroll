//
//  TopTitleModel.m
//  ScrollDemo
//
//  Created by 王文娟 on 16/7/5.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import "TopTitleModel.h"

@implementation TopTitleModel

-(instancetype)init{
    
    if (self = [super init]) {
        
        self.normalColor = [UIColor lightGrayColor];
        
        self.selectedColor = [UIColor blueColor];
        
        self.normalFont = [UIFont systemFontOfSize:13];
        
        self.selectedFont = [UIFont systemFontOfSize:15];

        self.lineColor = self.selectedColor;
        
        self.showLineWhenSelect = YES;
        
    }
    
    return self;

}

-(instancetype )initWithTitle:(NSString *)title{
    
    self = [self init];

    self.title = title;
    
    return self;

}

+(instancetype )modelWithTitle:(NSString *)title{

    return [[self alloc]initWithTitle:title];

}
@end
