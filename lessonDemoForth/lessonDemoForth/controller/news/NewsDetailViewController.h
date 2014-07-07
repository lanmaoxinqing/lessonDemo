//
//  NewsDetailViewController.h
//  lessonDemoSecond
//
//  Created by sky on 14-6-14.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsInfo.h"

@interface NewsDetailViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webview_;
}

@property(nonatomic,assign) NewsInfo *newsInfo;

@end
