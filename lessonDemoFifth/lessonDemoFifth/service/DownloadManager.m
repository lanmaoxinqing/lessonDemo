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
@property(nonatomic,strong) NSURLSession *session;

@end

@implementation DownloadManager

+(instancetype)sharedManager{
    static DownloadManager *manager=nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager=[[DownloadManager alloc] init];
        manager.taskDic=[NSMutableDictionary new];
        NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager.session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:manager delegateQueue:nil];
    });
    return manager;
}

-(id)init{
    self=[super init];
    if(self){
        self.taskDic=[NSMutableDictionary new];
        NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:self delegateQueue:nil];
    }
    return self;
}

-(void)resume:(NSString *)urlStr{
    NSURLSessionDownloadTask *task=[self taskWithURL:urlStr];
    [task resume];
}

-(void)pause:(NSString *)urlStr{
    NSURLSessionDownloadTask *task=[self taskWithURL:urlStr];
    [task suspend];
    [task cancelByProducingResumeData:^(NSData *resumeData) {
        NSString *tempPath=[[Sysconfig filePathByName:urlStr] stringByAppendingString:@".tmp"];
        [resumeData writeToFile:tempPath atomically:YES];
        [self.taskDic removeObjectForKey:urlStr];
    }];
}

-(void)cancel:(NSString *)urlStr{
    NSURLSessionDownloadTask *task=[self taskWithURL:urlStr];
    [task cancelByProducingResumeData:^(NSData *resumeData) {
        NSString *tempPath=[[Sysconfig filePathByName:urlStr] stringByAppendingString:@".tmp"];
        [resumeData writeToFile:tempPath atomically:YES];
        [self.taskDic removeObjectForKey:urlStr];
    }];
}

-(NSURLSessionDownloadTask *)taskWithURL:(NSString *)urlStr{
    NSURLSessionDownloadTask *task=[_taskDic objectForKey:urlStr];
    if(!task){
        NSString *tempPath=[[Sysconfig filePathByName:urlStr] stringByAppendingString:@".tmp"];
        if([[NSFileManager defaultManager] fileExistsAtPath:tempPath]){
            NSData *data=[NSData dataWithContentsOfFile:tempPath];
            task=[_session downloadTaskWithResumeData:data];
            [_taskDic setObject:task forKey:urlStr];
        }else{
            NSURL *url=[NSURL URLWithString:urlStr];
            task=[_session downloadTaskWithURL:url];
            [_taskDic setObject:task forKey:urlStr];
        }
    }
    return task;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSLog(@"%lli,%lli",totalBytesWritten,totalBytesExpectedToWrite);
    if(_delegate && [_delegate respondsToSelector:@selector(URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)]){
        [_delegate URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *filePath=[Sysconfig filePathByName:downloadTask.currentRequest.URL.absoluteString];
    NSError *error=nil;
    [[NSFileManager defaultManager] moveItemAtPath:location.relativePath toPath:filePath error:&error];
    if(error){
        NSLog(@"%@",[error description]);
    }
    if(_delegate && [_delegate respondsToSelector:@selector(URLSession:downloadTask:didFinishDownloadingToURL:)]){
        [_delegate URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
    }
}

//-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
//    
//}

@end
