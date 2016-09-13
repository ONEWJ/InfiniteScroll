//
//  TestViewController.m
//  ScrollDemo
//
//  Created by 王文娟 on 16/7/11.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
