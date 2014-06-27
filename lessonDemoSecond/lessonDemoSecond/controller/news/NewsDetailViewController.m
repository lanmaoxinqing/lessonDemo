//
//  NewsDetailViewController.m
//  lessonDemoSecond
//
//  Created by sky on 14-6-14.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "SuggestViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

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
    //添加投诉按钮
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithTitle:@"投诉" style:UIBarButtonItemStylePlain target:self action:@selector(didSuggestBtnClick:)];
    [self.navigationItem setRightBarButtonItem:item];
    //设置标题
    self.title=_newsInfo.title;
    //显示导航条(用于返回前一页)
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //根据ID加载新闻详情
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseService *base=[[BaseService alloc] init];
    base.url=[NSString stringWithFormat:@"http://api.blbaidu.cn/API/New.ashx?id=%ld",_newsInfo.newsId];
    [base requestWithCompletionHandler:^(NSString *responseStr, NSURLResponse *response, NSError *error) {
        NSDictionary *responseDic=[responseStr objectFromJSONString];
        NSString *description=[responseDic objectForKey:@"description"];
        [webview_ loadHTMLString:description baseURL:nil];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark -
-(void)didSuggestBtnClick:(id)sender{
    SuggestViewController *suggestVC=[[SuggestViewController alloc] initWithNibName:@"SuggestViewController" bundle:nil];
    [self.navigationController pushViewController:suggestVC animated:YES];
}


@end
