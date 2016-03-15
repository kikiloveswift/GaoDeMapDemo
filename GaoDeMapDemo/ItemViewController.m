//
//  ItemViewController.m
//  GaoDeMapDemo
//
//  Created by kong on 16/3/12.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self hiddenOrShowTabBar];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];

  
    
}

/**
 *  隐藏或者显示TabBar  二级界面隐藏 一级界面显示
 */
- (void)hiddenOrShowTabBar{

    NSArray *VCCounts = self.navigationController.viewControllers;
    
    NSInteger count = VCCounts.count;
    
    switch (count) {
        case 1:
            self.tabBarController.tabBar.hidden = NO;
            break;
        default:
            self.tabBarController.tabBar.hidden = YES;
            break;
    }

}
@end
