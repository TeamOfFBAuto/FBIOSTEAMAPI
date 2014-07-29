//
//  RootViewController.h
//  GMScan
//
//  Created by gaomeng on 14-7-29.
//  Copyright (c) 2014年 gaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController


-(void)pushWebViewWithStr:(NSString *)stringValue;



@property(nonatomic,strong)NSString *resultStr;

@end
