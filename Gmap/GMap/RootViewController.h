//
//  RootViewController.h
//  GMap
//
//  Created by gaomeng on 14-9-12.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface RootViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView *_mapView;//地图
    BMKLocationService *_locService;//定位服务
    
    
    BOOL _isOverLay;
    
    BMKOfflineMap* _offlineMap;//离线地图
}



@end
