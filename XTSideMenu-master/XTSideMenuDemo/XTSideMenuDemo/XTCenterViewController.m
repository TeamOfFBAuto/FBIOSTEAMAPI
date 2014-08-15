//
//  XTCenterViewController.m
//  XTSideMenuDemo
//
//  Created by XT on 14-8-14.
//  Copyright (c) 2014年 XT. All rights reserved.
//

#import "XTCenterViewController.h"
#import "UIViewController+XTSideMenu.h"
#import "XTSideMenu.h"

@interface XTCenterViewController ()
@property (strong, nonatomic) UIImageView *backImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@end

@implementation XTCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.headerView.backgroundColor = [UIColor redColor];
    
    if (![self respondsToSelector:@selector(topLayoutGuide)])
    {
        self.headerViewHeightConstraint.constant = self.headerViewHeightConstraint.constant - 20;
    }
    
    self.backImage = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView;
    });
    
    NSLog(@"%f",CGRectGetHeight(self.view.bounds));
    
    
    if (CGRectGetHeight(self.view.bounds) > 500)
    {
        self.backImage.image = [UIImage imageNamed:@"1136.jpg"];
    }
    else
    {
        self.backImage.image = [UIImage imageNamed:@"960.jpg"];
    }
    [self.view insertSubview:self.backImage atIndex:0];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)showLeftMenu:(UIButton *)sender {
    [self.sideMenuViewController presentLeftViewController];
}

- (IBAction)showRightMenu:(UIButton *)sender {
    [self.sideMenuViewController presentRightViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
