//
//  BottomTabViewController.m
//  lessonDemoFirst
//
//  Created by sky on 14-6-3.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "BottomTabViewController.h"
#import "ImageCollectionViewController.h"
#import "ImageListViewController.h"
#import "FavorViewController.h"

@interface BottomTabViewController ()

@end

@implementation BottomTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    //加载引导页
//    if(!guideVC_){
//        guideVC_=[[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
//        [self addChildViewController:guideVC_];
//        [self.view addSubview:guideVC_.view];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //底部tabbar按钮图标
    UIButton *newsBtn=[[UIButton alloc] initWithTitle:@"新闻" icon:@"btn_news"];
    UIButton *readBtn=[[UIButton alloc] initWithTitle:@"订阅" icon:@"btn_read"];
    UIButton *imageBtn=[[UIButton alloc] initWithTitle:@"图片" icon:@"btn_image"];
    UIButton *videoBtn=[[UIButton alloc] initWithTitle:@"视频" icon:@"btn_video"];
    self.tabBarBackgroundImage=[UIImage imageNamed:@"tab_bg"];
    self.tabBarBtnArray=[@[newsBtn,readBtn,imageBtn,videoBtn] mutableCopy];
    //第一个页面
    TopNavViewController *topVC=[[TopNavViewController alloc] initWithNibName:@"TopNavViewController" bundle:nil];
    UINavigationController *topNav=[[UINavigationController alloc] initWithRootViewController:topVC];
    ImageCollectionViewController *imageCollectionVC=[[ImageCollectionViewController alloc] initWithNibName:@"ImageCollectionViewController" bundle:nil];
    UINavigationController *imageCollectionNav=[[UINavigationController alloc] initWithRootViewController:imageCollectionVC];
    ImageListViewController *imageListVC=[[ImageListViewController alloc] initWithNibName:@"ImageListViewController" bundle:nil];
    FavorViewController *favorVC=[[FavorViewController alloc] initWithNibName:@"FavorViewController" bundle:nil];
    UINavigationController *favorNav=[[UINavigationController alloc] initWithRootViewController:favorVC];
    UINavigationController *imageListNav=[[UINavigationController alloc] initWithRootViewController:imageListVC];
    self.viewControllers=@[topNav,imageCollectionNav,imageListNav,favorNav];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
