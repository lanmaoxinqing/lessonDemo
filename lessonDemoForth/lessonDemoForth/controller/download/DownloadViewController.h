//
//  DownloadViewController.h
//  lessonDemoForth
//
//  Created by sky on 14-7-11.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDownloadDelegate>{
    IBOutlet UITableView *tableview_;
    NSArray *resources_;
}

@end
