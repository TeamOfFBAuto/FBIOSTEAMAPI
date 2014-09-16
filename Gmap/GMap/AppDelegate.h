//
//  AppDelegate.h
//  GMap
//
//  Created by gaomeng on 14-9-12.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //百度地图
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

@end
