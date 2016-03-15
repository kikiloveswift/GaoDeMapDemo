//
//  MapDetailViewController.m
//  GaoDeMapDemo
//
//  Created by kong on 16/3/12.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "MapDetailViewController.h"

#import <MAMapKit/MAMapKit.h>

#import <AMapSearchKit/AMapSearchKit.h>

@interface MapDetailViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    
    AMapSearchAPI *_search;
    
    CLLocation *_currentLocation;

}

@end

@implementation MapDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self initUI];

}

/**
 *  初始化UI
 */
- (void)initUI{
    
    //设置APIkey
    [[MAMapServices sharedServices]setApiKey:APIKEY];
    
    //初始化MapView
    _mapView               = [[MAMapView alloc] initWithFrame:self.view.bounds];

    _mapView.delegate      = self;

    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22 + 64);

    _mapView.scaleOrigin   = CGPointMake(_mapView.scaleOrigin.x, 22 + 64);
    
    //开启mapView定位
    _mapView.showsUserLocation = YES;
    
    //缩放级别
    _mapView.zoomLevel = 15;

    [self.view addSubview:_mapView];
    
    //创建定位BUTTON
    UIButton *localButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    localButton.frame = CGRectMake(15, kScreenHeight - 50, 20, 20);
    
    [localButton setBackgroundImage:[UIImage imageNamed:@"default_account_gender_radiobtn_normal"] forState:UIControlStateNormal];
    
    [localButton addTarget:self action:@selector(localBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:localButton];
    
    //初始化search------官方文档说了,初始化search之前必须先设KEY
    [AMapSearchServices sharedServices].apiKey = APIKEY;
    
    _search = [[AMapSearchAPI alloc] init];
    
    _search.delegate = self;
    
    //添加附近
    //创建定位BUTTON
    UIButton *nearByButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    localButton.frame = CGRectMake(localButton.right + 20, kScreenHeight - 50, 20, 20);
    
//    [localButton setBackgroundImage:[UIImage imageNamed:]forState:UIControlStateNormal];
    
    [localButton addTarget:self action:@selector(localBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:localButton];
    

}

#pragma  mark --- MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{

    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        [self requestSearchWith:_currentLocation.coordinate];
    }

}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{

    [self requestSearchWith:coordinate];

}

/**
 *  mapView已经获取到用户的位置
 *
 *  @param mapView          地图
 *  @param userLocation     用户坐标
 *  @param updatingLocation   这个方法只要设备移动就会调一次 实时调用
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    
    NSLog(@"user's loacation : %@",userLocation.location);
    
    if (_currentLocation == nil) {
        //设置中心经纬度坐标
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    }
    
    _currentLocation = [userLocation.location copy];
}

/**
 *  定位按钮
 *
 *  @param btn
 */
- (void)localBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"default_account_gender_radiobtn_highlighted"] forState:UIControlStateNormal];
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"default_account_gender_radiobtn_normal"] forState:UIControlStateNormal];
    
    }
    
    if (_currentLocation) {
        //设置中心经纬度坐标
        [_mapView setCenterCoordinate:_currentLocation.coordinate animated:YES];
    }
    
    
}

/**
 *  发起搜索请求
 */
- (void)requestSearchWith:(CLLocationCoordinate2D)currentCoordinate{
         //逆地理编码
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        request.location = [AMapGeoPoint locationWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude];
        
        [_search AMapReGoecodeSearch:request];
        
        
    

    
}

#pragma  mark- 搜索出错之后的回调

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{

    NSLog(@"error is %@\nreques is %@",error,request);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{

    NSString *title = response.regeocode.addressComponent.city;
    
    //如果标题为空
    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
    }
    
    _mapView.userLocation.title = title;
    
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    
}






@end
