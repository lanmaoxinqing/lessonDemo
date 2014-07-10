//
//  NewsDetailViewController.m
//  lessonDemoSecond
//
//  Created by sky on 14-6-14.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "SuggestViewController.h"
#import "FavorDao.h"
#import "Favor.h"

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
    UIBarButtonItem *suggestItem=[[UIBarButtonItem alloc] initWithTitle:@"投诉" style:UIBarButtonItemStylePlain target:self action:@selector(didSuggestBtnClick:)];
    UIBarButtonItem *favorItem=[[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(didFavorBtnClick:)];
    
    [self.navigationItem setRightBarButtonItems:@[favorItem,suggestItem]];
    //设置标题
    self.title=_newsInfo.title;
    //显示导航条(用于返回前一页)
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //根据ID加载新闻详情
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BaseService *base=[[BaseService alloc] init];
    base.url=[NSString stringWithFormat:@"http://api.blbaidu.cn/API/New.ashx?id=%ld",_newsInfo.sid];
    [base requestWithCompletionHandler:^(NSString *responseStr, NSURLResponse *response, NSError *error) {
        NSDictionary *responseDic=[responseStr objectFromJSONString];
        NSString *description=[responseDic objectForKey:@"description"];
//        NSString *text=[NSString stringWithFormat:@"javascript:test(%@)",description];
//        [webview_ stringByEvaluatingJavaScriptFromString:text];
//        NSURL *url=[NSURL fileURLWithPath:<#(NSString *)#>]
//        NSURLRequest *request=[NSURLRequest requestWithURL:<#(NSURL *)#>]
//        webview_ loadRequest:<#(NSURLRequest *)#>
        [webview_ loadHTMLString:description baseURL:nil];
    }];
    
//    NSString *filePath=[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"test.html"];
//    NSString *content=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [webview_ loadHTMLString:content baseURL:nil];
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

-(void)didFavorBtnClick:(id)sender{
    BaseDao *baseDao=[BaseDao sharedDao];
    FavorDao *favorDao=[FavorDao new];
    if([favorDao isFavorExistsById:_newsInfo.sid type:_newsInfo.type]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"收藏已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        Favor *favor=[Favor new];
        favor.objId=_newsInfo.sid;
        favor.type=_newsInfo.type;
        favor.title=_newsInfo.title;
        [baseDao insert:favor];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
