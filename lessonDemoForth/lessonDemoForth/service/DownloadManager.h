//
//  DownloadManager.h
//  lessonDemoForth
//
//  Created by sky on 14-7-11.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject<NSURLSessionDownloadDelegate>
@property(nonatomic,assign) id<NSURLSessionDownloadDelegate> delegate;

+(instancetype)sharedManager;

-(NSURLSessionDownloadTask *)taskWithURL:(NSString *)urlStr;
-(void)resume:(NSString *)urlStr;
-(void)pause:(NSString *)urlStr;
-(void)cancel:(NSString *)urlStr;

@end
