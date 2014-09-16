//
//  RootViewController.m
//  GMap
//
//  Created by gaomeng on 14-9-12.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
//    _offlineMap.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
//    _offlineMap.delegate = nil; // 不用时,置 nil
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    //地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [_mapView setZoomLevel:18];// 设置地图级别
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.delegate = self;//设置代理
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    [self.view addSubview:_mapView];
    

    //定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    
    
    _isOverLay = NO;
    
    
    
    
    
    
}


#pragma mark - 地图view代理方法 BMKMapViewDelegate
//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
		return groundView;
    }
	return nil;
}


#pragma mark - 定位代理方法

//在地图View将要启动定位时，会调用此函数
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}


//用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}


//用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
    [_mapView updateLocationData:userLocation];
    
    
    //判断是否有经纬度
    if (userLocation.location) {//有经纬度的话 停止定位 上传自己坐标
        
//        [_locService stopUserLocationService];//关掉定位
        
        if (!_isOverLay) {
            _isOverLay = YES;
            _mapView.centerCoordinate = userLocation.location.coordinate;
            
//            //提供两个经纬度 添加图片覆盖物
//            CLLocationCoordinate2D coords[2] = {0};
//            coords[0].latitude = userLocation.location.coordinate.latitude;
//            coords[0].longitude = userLocation.location.coordinate.longitude;
//            coords[1].latitude = 39.983;
//            coords[1].longitude = 116.352;
//            BMKCoordinateBounds bound;
//            bound.southWest = coords[0];//西南角经纬度
//            bound.northEast = coords[1];//东北角经纬度
//            
//            //地图浮层
//            BMKGroundOverlay* ground1 = [BMKGroundOverlay groundOverlayWithBounds:bound icon:[UIImage imageNamed:@"test.png"]];
            
            
            CLLocationCoordinate2D coords1[2] = {0};
            coords1[0].latitude = 39.982151;
            coords1[0].longitude = 116.375128;
            coords1[1].latitude = 39.983209;
            coords1[1].longitude = 116.376844;
            BMKCoordinateBounds bound2;
            bound2.southWest = coords1[0];
            bound2.northEast = coords1[1];
            BMKGroundOverlay *ground2 = [BMKGroundOverlay groundOverlayWithBounds:bound2 icon:[UIImage imageNamed:@"test.png"]];
            
//            [_mapView addOverlay:ground1];
            [_mapView addOverlay:ground2];

        }
        
        
        
        
    }
    
}


//定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
