//
//  DownloadViewController.h
//  lessonDemoForth
//
//  Created by sky on 14-7-11.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DownloadCell.h"
#import <QuickLook/QuickLook.h>

@interface DownloadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDownloadDelegate,MPMediaPickerControllerDelegate,DownloadCellDelegate,QLPreviewControllerDataSource>{
    IBOutlet UITableView *tableview_;
    NSArray *resources_;
    MPMoviePlayerViewController *player;
}

@end
