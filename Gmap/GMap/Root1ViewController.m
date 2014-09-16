//
//  Root1ViewController.m
//  GMap
//
//  Created by gaomeng on 14-9-14.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "Root1ViewController.h"
#import "RootViewController.h"

@interface Root1ViewController ()

@end

@implementation Root1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)dealloc
{
    if (_offlineMap != nil) {
        
        _offlineMap = nil; }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //初始化离线地图服务
    _offlineMap = [[BMKOfflineMap alloc]init];
    _offlineMap.delegate = self;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tiao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [btn1 setTitle:@"下载北京" forState:UIControlStateNormal];
//    btn1.frame = CGRectMake(100, 210, 100, 100);
//    [btn1 addTarget:self action:@selector(xiazai) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1];

    
    
    //归档拷贝 不好用 艹
//    [self guidangcopy];
    
    
    //把工程里的vmp文件夹 复制到沙盒里
    //不能整个vmp文件夹拷贝到documents 那就一个一个拷贝
    [self creatFileFolderWithFileName:@"vmp"];
    [self creatFileFolderWithFileName:@"vmp/h"];
    [self creatFileFolderWithFileName:@"vmp/h/traffic"];
    [self writeDocumentsWithFileName:@"vmp/h/beijing_131.dat" originPathName:@"beijing_131" originType:@"dat"];
    [self writeDocumentsWithFileName:@"vmp/h/DVUserdat.cfg" originPathName:@"DVUserdat" originType:@"cfg"];
    
    
    
    
    
}



#pragma mark - 写到documents

//拷贝文件
///fileName:沙盒里文件的名字.类型    originPathName:工程里文件的名字       originType:工程里文件的类型
-(void)writeDocumentsWithFileName:(NSString *)fileName originPathName:(NSString *)originPathName originType:(NSString *)originType {
    //沙盒中sql文件的路径
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *FilePath = [docPath stringByAppendingPathComponent:fileName];
	//原始sql文件路径
	NSString *originFilePath = [[NSBundle mainBundle] pathForResource:originPathName ofType:originType];
	
	NSFileManager *fm = [NSFileManager defaultManager];//文件管理器
	if([fm fileExistsAtPath:FilePath] == NO)//如果文件不在doc下，copy过来
	{
		NSError *error = nil;
		if([fm copyItemAtPath:originFilePath toPath:FilePath error:&error] == NO)
		{
			NSLog(@"拷贝文件错误");
		}else{
            NSLog(@"拷贝文件成功");
        }
	}else{
        NSLog(@"文件已存在");
    }
	
	
}

//创建文件夹
///需要添加的文件夹名字
-(void)creatFileFolderWithFileName:(NSString *)fileName{
    //沙盒中sql文件的路径
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *FilePath = [docPath stringByAppendingPathComponent:fileName];//沙盒路径
    
    NSFileManager *fm = [NSFileManager defaultManager];//文件管理器
    
    if([fm fileExistsAtPath:FilePath] == NO)//没有文件 添加
	{
		NSError *error = nil;
        
        if ([fm createDirectoryAtPath:FilePath withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            NSLog(@"拷贝文件夹错误");
        }else{
            NSLog(@"拷贝文件夹成功");
        }
	}else{
        NSLog(@"文件夹已存在");
    }
	
	
    
}



#pragma mark btn点击方法
-(void)tiao{
    [self.navigationController pushViewController:[[RootViewController alloc]init] animated:YES];
}

-(void)xiazai{
    //启动下载指定城市
    [self start:131];
}


#pragma mark - 离线地图

//添加对离线地图的监听方法
//离线地图delegate，用于获取通知
- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio);
    }
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"是否有更新%d",updateInfo.update);
    }
    if (type == TYPE_OFFLINE_UNZIP) {
        //正在解压第state个离线包，导入时会回调此类型
    }
    if (type == TYPE_OFFLINE_ZIPCNT) {
        //检测到state个离线包，开始导入时会回调此类型
        NSLog(@"检测到%d个离线包",state);
        if(state==0)
        {
            [self showImportMesg:state];
        }
    }
    if (type == TYPE_OFFLINE_ERRZIP) {
        //有state个错误包，导入完成后会回调此类型
        NSLog(@"有%d个离线包导入错误",state);
    }
    if (type == TYPE_OFFLINE_UNZIPFINISH) {
        NSLog(@"成功导入%d个离线包",state);
        //导入成功state个离线包，导入成功后会回调此类型
        [self showImportMesg:state];
    }
    
}


/**
 *启动下载指定城市 id 的离线地图 *@param cityID 指定的城市 id
 *@return 成功返回 YES,否则返回 NO
 */
- (BOOL)start:(int)cityID{
    
    return [_offlineMap start:cityID];
}

//导入提示框
- (void)showImportMesg:(int)count
{
    NSString* showmeg = [NSString stringWithFormat:@"成功导入离线地图包个数:%d", count];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"导入离线地图" message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [myAlertView show];
    
}





#pragma mark - 归档拷贝
-(void)guidangcopy{
        //获取document路径
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //归档和反归档==============================
        NSString *path1 = [NSHomeDirectory() stringByAppendingPathComponent:@"vmp"];
        //归档--------
        NSMutableData *data1 = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data1];
        //使用archiver归档遵循归档协议的类
        [archiver encodeDataObject:[NSData dataWithContentsOfFile:path1]];
        [archiver finishEncoding];
        //写数据
        [data1 writeToFile:path1 atomically:YES];
        [fileManager createFileAtPath:documentsDirectory contents:data1 attributes:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
