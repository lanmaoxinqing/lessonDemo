//
//  WelcomeViewController.m
//  lessonTest
//
//  Created by sky on 14-5-20.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "BottomTabViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    //使用弱指针,防止循环引用
    __weak UIView *view=backgroundView_;
    __weak id obj=self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //获取logo图片地址
    BaseService *base=[[BaseService alloc] init];
    base.url=@"http://api.blbaidu.cn/API/logo.ashx";
    [base requestWithCompletionHandler:^(NSString *responseStr, NSURLResponse *response, NSError *error) {
        NSDictionary *responseDic=[responseStr objectFromJSONString];
        NSString *logoPath=[responseDic objectForKey:@"pic"];
        //根据图片地址获取网络logo图片
        if(logoPath){
            [backgroundView_ setImageWithURL:[NSURL URLWithString:logoPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [MBProgressHUD hideHUDForView:[(WelcomeViewController *)obj view] animated:YES];
                [UIView animateWithDuration:3 animations:^{
                    view.transform=CGAffineTransformMakeScale(2, 2);
                    view.alpha=0;
                } completion:^(BOOL finished) {
                    [obj toGuideViewController];
                }];
            }];
        }else{
            [obj toGuideViewController];
        }
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toGuideViewController{
    BottomTabViewController *bottomTabVC=[[BottomTabViewController alloc] init];
    [[UIApplication sharedApplication] keyWindow].rootViewController=bottomTabVC;
}

@end
