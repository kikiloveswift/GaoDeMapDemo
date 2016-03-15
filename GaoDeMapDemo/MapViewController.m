//
//  MapViewController.m
//  GaoDeMapDemo
//
//  Created by kong on 16/3/12.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "MapViewController.h"
#import "MapDetailViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
}

/**
 *  初始化UI
 */
- (void)initUI{

    self.view.backgroundColor = [UIColor whiteColor];

    //TODO: Bundle ID
    NSString *bundleID        = [[NSBundle mainBundle] bundleIdentifier];

    NSLog(@"bundleID          = %@\n",bundleID);

    //展示详细地图
    UIButton *button          = [UIButton buttonWithType:UIButtonTypeCustom];

    button.frame              = CGRectMake((kScreenWidth - 200) / 2, 200, 200, 100);

    [button setTitle:@"详细地图页" forState:UIControlStateNormal];

    button.backgroundColor    = [UIColor orangeColor];

    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}


/**
 *  详细地图页
 *
 *  @param button
 */
- (void)btnAction:(UIButton *)button{
    
    MapDetailViewController *detailMap = [[MapDetailViewController alloc] init];
    
    [self.navigationController pushViewController:detailMap animated:YES];

}


@end
