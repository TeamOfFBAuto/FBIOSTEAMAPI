//
//  GscanfViewController.h
//  GMScan
//
//  Created by gaomeng on 14-7-29.
//  Copyright (c) 2014年 gaomeng. All rights reserved.
//

//扫一扫VC
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class RootViewController;

@interface GscanfViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) UIView * line;

@property(nonatomic,assign)RootViewController *delegete;




@end
