//
//  DownloadCell.h
//  leziyou-iphone
//
//  Created by mac on 12-4-16.
//  Copyright (c) 2012年 teemax. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownloadCellDelegate;

@interface DownloadCell : UITableViewCell{
    IBOutlet UIProgressView *progress;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *button;
    NSURLSessionDownloadTask *task_;
}

@property(nonatomic,assign) id<DownloadCellDelegate> delegate;
@property(nonatomic,assign) NSURLSessionTaskState state;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *downloadUrl;
-(void)downloadStart;
-(void)downloadContinue;
-(void)downloadPause;
-(void)finishButtonClicked;

@end


@protocol DownloadCellDelegate<NSObject>
@optional
-(BOOL)DownloadCellShouldStartDownload:(DownloadCell *)cell;//开始下载按钮点击后回调事件
-(BOOL)DownloadCellShouldPauseDownload:(DownloadCell *)cell;//暂停按钮点击后回调事件
-(void)DownloadCellDidFinishedDownload:(DownloadCell *)cell;//下载完成后回调事件
-(void)DownloadCellDidFinishButtonClicked:(DownloadCell *)cell;//下载完成后点击按钮需要响应的事件
-(void)DownloadCell:(DownloadCell *)cell downloadFailedWithError:(NSError *)error;

@end
