//
//  DownloadManager.h
//  lessonDemoForth
//
//  Created by sky on 14-7-11.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotificationProgress @"kNotificationProgress"
#define kNotificationComplete @"kNotificationComplete"


@interface DownloadManager : NSObject<NSURLSessionDownloadDelegate>

+(instancetype)sharedManager;

-(NSURLSessionDownloadTask *)taskWithURL:(NSString *)urlStr;
-(void)resume:(NSString *)urlStr;
-(void)pause:(NSString *)urlStr;
-(void)cancel:(NSString *)urlStr;

@end
