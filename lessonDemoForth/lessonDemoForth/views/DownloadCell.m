//
//  DownloadCell.m
//  leziyou-iphone
//
//  Created by mac on 12-4-16.
//  Copyright (c) 2012年 teemax. All rights reserved.
//

#import "DownloadCell.h"
#import "DownloadManager.h"

@interface DownloadCell(Private)
-(void) callBackError:(NSString *)errorInfo;
@end

@implementation DownloadCell
@synthesize state,title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public method
-(void)downloadStart{
    if(![_delegate respondsToSelector:@selector(DownloadCellShouldStartDownload:)] || [_delegate DownloadCellShouldStartDownload:self]){
        if(_downloadUrl && [_downloadUrl length]>4){
            [[DownloadManager sharedManager] resume:_downloadUrl];
            self.state=NSURLSessionTaskStateRunning;
        }else{
            [self callBackError:@"下载路径为空"];
        }
    }
}

-(void)downloadPause{
    if(![_delegate respondsToSelector:@selector(DownloadCellShouldPauseDownload:)] || [_delegate DownloadCellShouldPauseDownload:self]){
        [[DownloadManager sharedManager] pause:_downloadUrl];
        self.state=NSURLSessionTaskStateSuspended;
    }
}

-(void)downloadContinue{
    if(![_delegate respondsToSelector:@selector(DownloadCellShouldStartDownload:)] || [_delegate DownloadCellShouldStartDownload:self]){
        [[DownloadManager sharedManager] resume:_downloadUrl];
        self.state=NSURLSessionTaskStateRunning;
    }
}

-(void)finishButtonClicked{
    if([_delegate respondsToSelector:@selector(DownloadCellDidFinishButtonClicked:)]){
        [_delegate DownloadCellDidFinishButtonClicked:self];
    }
}

#pragma mark - private methods
-(void)callBackError:(NSString *)errorInfo{
    if([_delegate respondsToSelector:@selector(DownloadCell:downloadFailedWithError:)]){
        NSDictionary *dic=[NSDictionary dictionaryWithObject:errorInfo forKey:NSLocalizedDescriptionKey];
        NSError *error=[NSError errorWithDomain:@"DownloadCell" code:100 userInfo:dic];
        [_delegate DownloadCell:self downloadFailedWithError:error];
    }
}

-(void)setTitle:(NSString *)name{
    title=[name copy];
    titleLabel.text=title;
}

-(void)setState:(NSURLSessionTaskState)downloadState{
    if(downloadState==NSURLSessionTaskStateSuspended){
        progress.hidden=NO;
        [button setBackgroundImage:[UIImage imageNamed:@"login_bt.png"] forState:UIControlStateNormal];
        [button removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(downloadStart) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"下载" forState:UIControlStateNormal];
    }else if(downloadState==NSURLSessionTaskStateRunning){
        progress.hidden=NO;
        [button removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(downloadPause) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"暂停" forState:UIControlStateNormal];
    }else if(downloadState==NSURLSessionTaskStateCompleted){
        progress.hidden=YES;
        [button setTitle:@"已下载" forState:UIControlStateNormal];
        [button removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(finishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    state=downloadState;
}

-(void)setDownloadUrl:(NSString *)downloadUrl{
    _downloadUrl=downloadUrl;
    NSURLSessionTask *task=[[DownloadManager sharedManager] taskWithURL:downloadUrl];
    self.state=task.state;
    self.title=task.description;
    progress.progress=task.countOfBytesReceived/(float)task.countOfBytesExpectedToReceive;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgress:) name:kNotificationProgress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(complete:) name:kNotificationComplete object:nil];
}

-(void)changeProgress:(NSNotification *)notify{
    NSURLSessionDownloadTask *downloadTask=[notify object];
    if(!task_ || task_.state!=NSURLSessionTaskStateRunning){
        task_=[[DownloadManager sharedManager] taskWithURL:_downloadUrl];
    }
//    NSURLSessionTask *task=[[DownloadManager sharedManager] taskWithURL:_downloadUrl];
    if([downloadTask isEqual:task_]){
        progress.progress=task_.countOfBytesReceived/(float)task_.countOfBytesExpectedToReceive;
    }
}

-(void)complete:(NSNotification *)notify{
    NSURLSessionDownloadTask *downloadTask=[notify object];
    NSURLSessionTask *task=[[DownloadManager sharedManager] taskWithURL:_downloadUrl];
    if([downloadTask isEqual:task]){
        self.state=NSURLSessionTaskStateCompleted;
    }
}

@end
