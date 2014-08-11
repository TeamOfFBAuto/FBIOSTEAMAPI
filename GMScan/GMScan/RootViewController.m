//
//  RootViewController.m
//  GMScan
//
//  Created by gaomeng on 14-7-29.
//  Copyright (c) 2014年 gaomeng. All rights reserved.
//

#import "RootViewController.h"

#import "GscanfViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saoyisao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 模态出扫一扫界面
-(void)saoyisao{
    GscanfViewController *gscanf = [[GscanfViewController alloc]init];
    gscanf.delegete = self;
    
    //push
//    [self.navigationController pushViewController:gscanf animated:YES];
    
    //模态
    [self presentViewController:gscanf animated:YES completion:^{
        
    }];
}


#pragma mark - 扫完后的回调
-(void)pushWebViewWithStr:(NSString *)stringValue{
    
    NSLog(@"%s",__FUNCTION__);
    
    NSLog(@"%@",stringValue);
    
//    FBCircleWebViewController *fbwebvc = [[FBCircleWebViewController alloc]init];
//    fbwebvc.web_url = stringValue;
//    
//    [self.navigationController pushViewController:fbwebvc animated:YES];
    
}


@end
