//
//  DownloadViewController.m
//  lessonDemoForth
//
//  Created by sky on 14-7-11.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadCell.h"
#import "DownloadManager.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

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
    DownloadManager *manager=[DownloadManager sharedManager];
    manager.delegate=self;
    resources_=@[@"http://58.216.26.101/youku/677537549C4438393FE6FD4283/030008010053AD23EB25CA06A9C1DB28766C54-FF0A-3FDB-DD19-0AA53FCDB6B4.mp4",@"http://222.73.61.134/youku/677366FCDF9428141BC33C61C1/030008070053B11D8DCCC2055DF53192864505-23EE-C761-8FFD-D110359DFD00.mp4",@"http://58.216.26.108/youku/6572D5D2FB34D841EC806F504A/030008070153B11D8DCCC2055DF53192864505-23EE-C761-8FFD-D110359DFD00.mp4",@"IOS.doc"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *urlStr=resources_[indexPath.row];
    DownloadCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DownloadCell"];
    if(!cell){
        cell=[[NSBundle mainBundle] loadNibNamed:@"DownloadCell" owner:nil options:nil][0];
    }
    cell.delegate=self;
    cell.downloadUrl=urlStr;
    NSString *filePath=[Sysconfig filePathByName:urlStr];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        cell.state=NSURLSessionTaskStateCompleted;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resources_.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *urlStr=resources_[indexPath.row];
    NSString *filePath=[Sysconfig filePathByName:urlStr];
    if([urlStr isEqualToString:@"IOS.doc"]){
        QLPreviewController *previewVC=[[QLPreviewController alloc] init];
        previewVC.dataSource = self;
        [self presentViewController:previewVC animated:YES completion:nil];
    }else if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        //播放本地视频
        NSURL *movieURL = [NSURL fileURLWithPath:filePath];//file://
        player = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
        [self presentMoviePlayerViewControllerAnimated:player];
        [player.moviePlayer play];
    }else{
        //播放在线视频
        NSURL *movieURL = [NSURL URLWithString:urlStr];//http://
        player = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
        [self presentMoviePlayerViewControllerAnimated:player];
        [player.moviePlayer play];

    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSString *urlStr=downloadTask.currentRequest.URL.absoluteString;
    NSInteger index=[resources_ indexOfObject:urlStr];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    DownloadCell *cell=(DownloadCell *)[tableview_ cellForRowAtIndexPath:indexPath];
    cell.progressValue=totalBytesWritten/(float)totalBytesExpectedToWrite;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *urlStr=downloadTask.currentRequest.URL.absoluteString;
    NSInteger index=[resources_ indexOfObject:urlStr];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    DownloadCell *cell=(DownloadCell *)[tableview_ cellForRowAtIndexPath:indexPath];
    cell.state=NSURLSessionTaskStateCompleted;
}

-(void)DownloadCellDidFinishButtonClicked:(DownloadCell *)cell{
    NSIndexPath *indexPath=[tableview_ indexPathForCell:cell];
    NSString *urlStr=resources_[indexPath.row];
    NSString *filePath=[Sysconfig filePathByName:urlStr];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        //播放视频
        NSURL *movieURL = [NSURL fileURLWithPath:filePath];
        player = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
        [self presentMoviePlayerViewControllerAnimated:player];
        [player.moviePlayer play];
    }
}

#pragma mark - QuickLook delegate
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}

- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    return [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IOS.doc"]];
//    return [NSURL URLWithString:@"192.168.1.35:36/Shared/res/%E9%A1%B9%E7%9B%AE%E7%BC%96%E5%8F%B7%E8%AF%B4%E6%98%8E%E4%B8%8E%E5%BF%AB%E6%8D%B7%E9%94%AE.doc"];
}


@end
