//
//  UIImageView+WebCache.m
//  lessonTest
//
//  Created by sky on 14-5-20.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "Sysconfig.h"

@implementation UIImageView (WebCache)

typedef void (^FinishBlock)(UIImage *image ,NSError *error);

-(void)setImageWithURL:(NSString *)url{
    [self setImageWithURL:url finish:nil];

}

-(void)setImageWithURL:(NSString *)urlStr finish:(FinishBlock)block{
    //检查系统资源
    NSString *localPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:urlStr];
    if([[NSFileManager defaultManager] fileExistsAtPath:localPath]){
        UIImage *image=[UIImage imageWithContentsOfFile:localPath];
        self.image=image;
        if(block){
            block(image,nil);
        }
        return;
    }
    //检查本地缓存
    NSString *downloadPath=[Sysconfig filePathByName:urlStr];
    if([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]){
        UIImage *image=[UIImage imageWithContentsOfFile:downloadPath];
        self.image=image;
        if(block){
            block(image,nil);
        }
        return;
    }
    //本地图片不存在
    UIView *waitView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    waitView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.4];
    waitView.center=self.center;
    [self addSubview:waitView];
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    activityView.center=CGPointMake(25, 25);
    [waitView addSubview:activityView];

    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [waitView removeFromSuperview];
        if(error){
            if(block){
                block(nil,error);
            }
            return;
        }
        //缓存图片
        NSString *downloadPath=[Sysconfig filePathByName:urlStr];
        [data writeToFile:downloadPath atomically:YES];
        //加载图片
        UIImage *image=[UIImage imageWithContentsOfFile:downloadPath];
        if(!image){
            NSError *error=[NSError errorWithDomain:@"UIImageView" code:-1000 userInfo:@{NSLocalizedDescriptionKey:@"图片不存在"}];
            if(block){
                block(nil,error);
            }
            return;
        }
        self.image=image;
        if(block){
            block(image,nil);
        }
    }];
    [dataTask resume];
}

@end
