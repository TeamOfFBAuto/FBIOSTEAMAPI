//
//  GscanfViewController.m
//  GMScan
//
//  Created by gaomeng on 14-7-29.
//  Copyright (c) 2014年 gaomeng. All rights reserved.
//

#import "GscanfViewController.h"
#import "RootViewController.h"
#import "ScanResultViewController.h"

#define ScanKuangFrame CGRectMake(50, 70+89, 220, 220)//扫描框的frame
#define CameraFrame CGRectMake(0,0,320,568);//相机frame

@interface GscanfViewController ()

@end

@implementation GscanfViewController



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //上面的功能按钮
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    upView.backgroundColor = [UIColor orangeColor];
    //返回按钮
    UIButton *bbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bbtn.frame = CGRectMake(0, 0, 60, 44);
    [bbtn setTitle:@"返回" forState:UIControlStateNormal];
    [bbtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:bbtn];
    [self.view addSubview:upView];
    
    
    //半透明的浮层
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 568-64)];
    backImageView.image = [UIImage imageNamed:@"saoyisao_bg_640_996.png"];
    [self.view addSubview:backImageView];
 
    
    //四个角
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:ScanKuangFrame];
    imageView.image = [UIImage imageNamed:@"saoyisao_440_440.png"];
    [self.view addSubview:imageView];
    
    
    //文字提示label
    UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame)+28, imageView.frame.size.width, 12)];
    tishiLabel.font = [UIFont systemFontOfSize:12];
    tishiLabel.textColor = [UIColor whiteColor];
    tishiLabel.backgroundColor = [UIColor clearColor];
    tishiLabel.text = @"将二维码显示在扫描框内，即可自动扫描";
    [self.view addSubview:tishiLabel];
    
    
    //我的二维码
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(124, CGRectGetMaxY(tishiLabel.frame)+37, 70, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [btn setTitle:@"我的二维码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    
    
    upOrdown = NO;
    num =0;
    
    //上下滚动的条
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(ScanKuangFrame.origin.x, ScanKuangFrame.origin.y, ScanKuangFrame.size.width, 2)];
    _line.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [timer fire];
    
    
}
-(void)animation1
{
    //一个条
    if (upOrdown == NO) {
        num ++;

        _line.frame = CGRectMake(ScanKuangFrame.origin.x, ScanKuangFrame.origin.y+2*num, 220, 2);
        if (2*num == 220) {

            upOrdown = YES;
        }

    }
    else {
        num --;
        _line.frame = CGRectMake(ScanKuangFrame.origin.x, ScanKuangFrame.origin.y+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}



-(void)viewWillAppear:(BOOL)animated
{
    
    if (!TARGET_IPHONE_SIMULATOR) {
        [self setupCamera];
    }
    
}



- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = CameraFrame;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
//扫一扫完成之后的回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    
    
    
    //如果是模态视图的话 模态视图消失之后推到扫一扫结果web页面
    [self dismissViewControllerAnimated:YES completion:^
     {
         [timer invalidate];
         NSLog(@"123");
         NSLog(@"%@",stringValue);
         
         [self.delegete pushWebViewWithStr:stringValue];
      
     }];
    
    
//    //如果是navigation的话无法在返回上一个vc之后再推到扫一扫结果web页面
//    [self.navigationController pushViewController:[[ScanResultViewController alloc]init] animated:YES];
    
    
    
    
    
    
}




#pragma mark - 点击我的二维码跳转
-(void)myErweima{
    NSLog(@"%s",__FUNCTION__);
}





@end
