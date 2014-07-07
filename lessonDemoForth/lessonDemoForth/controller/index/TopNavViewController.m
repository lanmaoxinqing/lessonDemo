//
//  TopNavViewController.m
//  lessonDemoSecond
//
//  Created by sky on 14-6-14.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "TopNavViewController.h"
#import "NewsListViewController.h"
#import "AnnouncementListViewController.h"

#define kTitleBtnDefaultTag 10000

@interface TopNavViewController ()

@end

@implementation TopNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //放在这里,使每次TapNavViewController出现时隐藏导航条,确保导航条不显示.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //不放在viewDidLoad中,是因为那时contentScrollView_还没根据屏幕大小调整高度,从而导致内容高度大于视图高度
    contentScrollView_.contentSize=CGSizeMake(contentScrollView_.frame.size.width*2, contentScrollView_.frame.size.height);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadTitleView:@[@"要闻",@"公告",@"娱乐",@"体育",@"财经",@"科技",@"房产",@"汽车",@"游戏"]];

    NewsListViewController *listVC=[[NewsListViewController alloc] initWithNibName:@"NewsListViewController" bundle:nil];
    [self addChildViewController:listVC];
    [contentScrollView_ addSubview:listVC.view];
    AnnouncementListViewController *announcementListVC=[[AnnouncementListViewController alloc] initWithNibName:@"AnnouncementListViewController" bundle:nil];
    [self addChildViewController:announcementListVC];
    [contentScrollView_ addSubview:announcementListVC.view];
    CGRect rect=announcementListVC.view.frame;
    rect.origin.x=contentScrollView_.frame.size.width;
    announcementListVC.view.frame=rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重新加载顶部视图
-(void)reloadTitleView:(NSArray *)titles{
    for(id subview in titleScrollView_.subviews){
        if([subview isKindOfClass:[UIButton class]]){
            [subview removeFromSuperview];
        }
    }
    
    //加载按钮的背景
    if(!titleSelectBg_){
        titleSelectBg_=[[UIView alloc] initWithFrame:CGRectMake(5, 0, 70, 39)];
        titleSelectBg_.backgroundColor=[[UIColor blueColor] colorWithAlphaComponent:.3];
        titleSelectBg_.layer.cornerRadius=6.0;
        [titleScrollView_ insertSubview:titleSelectBg_ atIndex:0];
    }

    //按钮遍历横向平铺,间距为10
    CGFloat totalWidth=10;
    titleScrollView_.contentSize=CGSizeMake(70*[titles count], 39);
    for(int i=0;i<[titles count];i++){
        NSString *title=titles[i];
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(totalWidth, 5, 60, 30)];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:.7] forState:UIControlStateSelected];
        btn.tag=i+kTitleBtnDefaultTag;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didTitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleScrollView_ addSubview:btn];
        totalWidth+=70;
    }
}

//顶部功能按钮点击事件
-(void)didTitleBtnClick:(UIButton *)sender{
    for(id subview in titleScrollView_.subviews){
        if([subview isKindOfClass:[UIButton class]]){
            [(UIButton *)subview setSelected:NO];
        }
    }
    sender.selected=YES;
    //设置点击按钮时背景移动的动画效果
    [UIView animateWithDuration:.3 animations:^{
        titleSelectBg_.center=sender.center;
        titleScrollView_.contentOffset=CGPointMake(MIN(MAX(0, sender.center.x-titleScrollView_.frame.size.width/2), MAX(0, titleScrollView_.contentSize.width-titleScrollView_.frame.size.width)) , 0);
    }];
    //内容视图划动到按钮对应页数,实现按钮与视图联动
    [contentScrollView_ scrollRectToVisible:CGRectMake((sender.tag-kTitleBtnDefaultTag)*contentScrollView_.frame.size.width, 0, contentScrollView_.frame.size.width, 1) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage=contentScrollView_.contentOffset.x/contentScrollView_.frame.size.width;
    UIButton *sender=(UIButton *)[titleScrollView_ viewWithTag:(currentPage+kTitleBtnDefaultTag)];
    //设置点击按钮时背景移动的动画效果
    [self didTitleBtnClick:sender];
}


@end
