//
//  RootViewController.h
//  GRefreTableView
//
//  Created by gaomeng on 14-8-11.
//  Copyright (c) 2014年 gaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRefreshTableView.h"

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    RefreshTableView *_tableView;//主tableview
}
@end
