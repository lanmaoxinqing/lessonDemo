//
//  DownloadManager.m
//  lessonDemoForth
//
//  Created by sky on 14-7-11.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "DownloadManager.h"

@interface DownloadManager ()

@property(nonatomic,strong) NSMutableDictionary *taskDic;
@property(nonatomic,strong) NSURLSession *currentSession;

@end

@implementation DownloadManager

+(instancetype)sharedManager{
    static DownloadManager *manager=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager=[[DownloadManager alloc] init];
        manager.taskDic=[NSMutableDictionary new];
        NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager.currentSession = [NSURLSession sessionWithConfiguration:defaultConfig delegate:manager delegateQueue:nil];
    });
    return manager;
}

-(void)resume:(NSString *)urlStr{
    NSURLSessionDownloadTask *task=[self taskWithURL:urlStr];
    [task resume];
}

-(void)pause:(NSString *)urlStr{
    NSURLSessionDownloadTask *task=[self taskWithURL:urlStr];
    [task cancelByProducingResumeData:^(NSData *resumeData) {
//        [task suspend];
        NSString *tempPath=[[Sysconfig filePathByName:urlStr] stringByAppendingString:@".tmp"];
        [resumeData writeToFile:tempPath atomically:YES];
    }];
}

-(void)cancel:(NSString *)urlStr{
    NSURLSessionDownloadTask *task=[self taskWithURL:urlStr];
    [task cancelByProducingResumeData:^(NSData *resumeData) {
        NSString *tempPath=[[Sysconfig filePathByName:urlStr] stringByAppendingString:@".tmp"];
        [resumeData writeToFile:tempPath atomically:YES];
    }];
}

-(NSURLSessionDownloadTask *)taskWithURL:(NSString *)urlStr{
    NSURLSessionDownloadTask *task=[_taskDic objectForKey:urlStr];
    NSString *tempPath=[[Sysconfig filePathByName:urlStr] stringByAppendingString:@".tmp"];
    if(!task || task.state==NSURLSessionTaskStateCompleted){
        if([[NSFileManager defaultManager] fileExistsAtPath:tempPath]){
            NSData *data=[NSData dataWithContentsOfFile:tempPath];
            task=[_currentSession downloadTaskWithResumeData:data];
            [_taskDic setObject:task forKey:urlStr];
        }else{
            NSURL *url=[NSURL URLWithString:urlStr];
            task=[_currentSession downloadTaskWithURL:url];
            [_taskDic setObject:task forKey:urlStr];
        }
    }
    return task;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSLog(@"%lli,%lli",totalBytesWritten,totalBytesExpectedToWrite);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProgress object:downloadTask];

}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *filePath=[Sysconfig filePathByName:downloadTask.currentRequest.URL.absoluteString];
    NSError *error=nil;
    [[NSFileManager defaultManager] moveItemAtPath:location.relativePath toPath:filePath error:&error];
    if(error){
        NSLog(@"%@",[error description]);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationComplete object:downloadTask];
}

@end
