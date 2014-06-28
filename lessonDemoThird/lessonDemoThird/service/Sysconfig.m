//
//  Sysconfig.m
//  lessonTest
//
//  Created by sky on 14-5-21.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "Sysconfig.h"

#define kRootFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/"]

@implementation Sysconfig

+(NSString *)filePathByName:(NSString *)fileName{
    NSString *filePath=nil;
    //分离文件名和后缀
    NSString *lastPath=[fileName lastPathComponent];
    NSRange range=[lastPath rangeOfString:@"." options:NSBackwardsSearch];
    NSString *fileType=@"other";
    if(range.location!=NSNotFound && lastPath.length>range.location){
        fileType=[lastPath substringFromIndex:range.location+1];
    }
    //使用全路径作为文件名（防止文件名重复）
    NSString *name = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    name = [name stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *newName=[name stringByAppendingFormat:@".%@",fileType];
    //根据文件后缀创建目录
    filePath=[kRootFolder stringByAppendingPathComponent:fileType];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //合成完整路径
    filePath=[filePath stringByAppendingPathComponent:newName];
    return filePath;
}

@end
