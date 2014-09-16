//
//  Root1ViewController.h
//  GMap
//
//  Created by gaomeng on 14-9-14.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"


@interface Root1ViewController : UIViewController<BMKOfflineMapDelegate,NSFileManagerDelegate>
{
    BMKOfflineMap* _offlineMap;//离线地图
}
@end
